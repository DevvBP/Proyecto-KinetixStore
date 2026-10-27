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

    public static final double ENVIO_LOCAL    = 0.0;
    public static final double ENVIO_ESTANDAR = 25000.0;
    public static final double ENVIO_EXPRESS  = 50000.0;
    public static final double ENVIO_PESADO   = 150000.0;

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

    public double calcularEnvio(String modalidad) {
        if (modalidad == null) return ENVIO_LOCAL;
        return switch (modalidad.toLowerCase()) {
            case "estandar" -> ENVIO_ESTANDAR;
            case "express"  -> ENVIO_EXPRESS;
            case "pesado"   -> ENVIO_PESADO;
            default         -> ENVIO_LOCAL;
        };
    }

    public double calcularTotal(HttpSession session, String modalidadEnvio) {
        return calcularSubtotal(session) + calcularEnvio(modalidadEnvio);
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
