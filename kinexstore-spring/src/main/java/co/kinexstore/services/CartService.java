package co.kinexstore.services;

import co.kinexstore.models.CartItem;
import co.kinexstore.models.Product;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CartService {

    private static final String SESSION_KEY = "carrito";

    public static final double ENVIO_LOCAL               = 0.0;
    public static final double TARIFA_BASE_ESTANDAR      = 15000.0;
    public static final double TARIFA_EXTRA_KG_ESTANDAR  = 2000.0;
    public static final double PESO_BASE_ESTANDAR        = 5.0;

    public static final double TARIFA_BASE_EXPRESS       = 25000.0;
    public static final double TARIFA_EXTRA_KG_EXPRESS   = 3500.0;
    public static final double PESO_BASE_EXPRESS         = 5.0;

    public static final double TARIFA_BASE_PESADO        = 80000.0;
    public static final double TARIFA_EXTRA_KG_PESADO    = 1500.0;
    public static final double PESO_BASE_PESADO          = 50.0;

    @SuppressWarnings("unchecked")
    public List<CartItem> getCarrito(HttpSession session) {
        List<CartItem> carrito = (List<CartItem>) session.getAttribute(SESSION_KEY);
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute(SESSION_KEY, carrito);
        }
        return carrito;
    }

    public void agregar(HttpSession session, Product product, int cantidad) {
        List<CartItem> carrito = getCarrito(session);

        Optional<CartItem> existing = carrito.stream()
                .filter(item -> item.getProduct() != null && item.getProduct().getId().equals(product.getId()))
                .findFirst();

        if (existing.isPresent()) {
            existing.get().setCantidad(existing.get().getCantidad() + cantidad);
        } else {
            carrito.add(new CartItem(product, cantidad));
        }
    }

    public void actualizarCantidad(HttpSession session, Long productId, int nuevaCantidad) {
        if (nuevaCantidad <= 0) {
            eliminar(session, productId);
            return;
        }
        List<CartItem> carrito = getCarrito(session);
        carrito.stream()
                .filter(item -> item.getProduct() != null && item.getProduct().getId().equals(productId))
                .findFirst()
                .ifPresent(item -> item.setCantidad(nuevaCantidad));
    }

    public void eliminar(HttpSession session, Long productId) {
        List<CartItem> carrito = getCarrito(session);
        carrito.removeIf(item -> item.getProduct() != null && item.getProduct().getId().equals(productId));
    }

    public void vaciar(HttpSession session) {
        session.removeAttribute(SESSION_KEY);
    }

    public double calcularSubtotal(HttpSession session) {
        return getCarrito(session).stream()
                .mapToDouble(CartItem::getSubtotal)
                .sum();
    }

    public double calcularEnvio(double pesoTotalKg, String modalidad) {
        if (modalidad == null || "local".equalsIgnoreCase(modalidad)) {
            return ENVIO_LOCAL;
        }

        double peso = Math.max(pesoTotalKg, 0.0);
        if (peso == 0.0) {
            return ENVIO_LOCAL;
        }

        return switch (modalidad.toLowerCase()) {
            case "estandar" -> {
                if (peso <= PESO_BASE_ESTANDAR) {
                    yield TARIFA_BASE_ESTANDAR;
                }
                double kgExtra = Math.ceil(peso - PESO_BASE_ESTANDAR);
                yield TARIFA_BASE_ESTANDAR + (kgExtra * TARIFA_EXTRA_KG_ESTANDAR);
            }
            case "express" -> {
                if (peso <= PESO_BASE_EXPRESS) {
                    yield TARIFA_BASE_EXPRESS;
                }
                double kgExtra = Math.ceil(peso - PESO_BASE_EXPRESS);
                yield TARIFA_BASE_EXPRESS + (kgExtra * TARIFA_EXTRA_KG_EXPRESS);
            }
            case "pesado" -> {
                if (peso <= PESO_BASE_PESADO) {
                    yield TARIFA_BASE_PESADO;
                }
                double kgExtra = Math.ceil(peso - PESO_BASE_PESADO);
                yield TARIFA_BASE_PESADO + (kgExtra * TARIFA_EXTRA_KG_PESADO);
            }
            default -> ENVIO_LOCAL;
        };
    }

    public double calcularEnvio(HttpSession session, String modalidad) {
        return calcularEnvio(getPesoTotal(session), modalidad);
    }

    public double calcularEnvio(String modalidad) {
        return calcularEnvio(1.0, modalidad);
    }

    public double calcularTotal(HttpSession session, String modalidadEnvio) {
        return calcularSubtotal(session) + calcularEnvio(session, modalidadEnvio);
    }

    public String getExplicacionFlete(double pesoKg, String modalidad) {
        if (modalidad == null || "local".equalsIgnoreCase(modalidad)) {
            return "Retiro en sede principal KinexStore (Sin costo logístico adicional).";
        }
        double peso = Math.max(pesoKg, 1.0);
        return switch (modalidad.toLowerCase()) {
            case "estandar" -> {
                if (peso <= PESO_BASE_ESTANDAR) {
                    yield String.format("Tarifa base estándar $ 15.000 COP aplicable hasta %.1f kg (Peso actual: %.2f kg).", PESO_BASE_ESTANDAR, peso);
                }
                double kgExtra = Math.ceil(peso - PESO_BASE_ESTANDAR);
                yield String.format("Tarifa base ($ 15.000 COP hasta 5 kg) + %.0f kg extra a $ 2.000 COP/kg (Total: %.2f kg).", kgExtra, peso);
            }
            case "express" -> {
                if (peso <= PESO_BASE_EXPRESS) {
                    yield String.format("Tarifa express prioritaria $ 25.000 COP aplicable hasta %.1f kg (Peso actual: %.2f kg).", PESO_BASE_EXPRESS, peso);
                }
                double kgExtra = Math.ceil(peso - PESO_BASE_EXPRESS);
                yield String.format("Tarifa express ($ 25.000 COP hasta 5 kg) + %.0f kg extra a $ 3.500 COP/kg (Total: %.2f kg).", kgExtra, peso);
            }
            case "pesado" -> {
                if (peso <= PESO_BASE_PESADO) {
                    yield String.format("Tarifa industrial pesado $ 80.000 COP hasta %.1f kg (Peso actual: %.2f kg).", PESO_BASE_PESADO, peso);
                }
                double kgExtra = Math.ceil(peso - PESO_BASE_PESADO);
                yield String.format("Tarifa industrial ($ 80.000 COP hasta 50 kg) + %.0f kg extra a $ 1.500 COP/kg (Total: %.2f kg).", kgExtra, peso);
            }
            default -> "Cotización según peso y cubicaje.";
        };
    }

    public int getTotalItems(HttpSession session) {
        return getCarrito(session).stream()
                .mapToInt(CartItem::getCantidad)
                .sum();
    }

    public double getPesoTotal(HttpSession session) {
        return getCarrito(session).stream()
                .mapToDouble(CartItem::getPesoTotal)
                .sum();
    }

    public String sugerirModalidadEnvio(HttpSession session) {
        double peso = getPesoTotal(session);
        if (peso > 50) return "pesado";
        if (peso > 10) return "estandar";
        return "local";
    }

    public String formatearCOP(double valor) {
        return String.format("$ %,.0f COP", valor).replace(",", ".");
    }
}
