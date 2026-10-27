package co.kinexstore.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Locale;

/**
 * Modelo DTO/POJO que representa un ítem dentro del carrito de compras en sesión HTTP.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private Product product;
    private int cantidad;

    public double getSubtotal() {
        if (product == null) return 0.0;
        return product.calcularPrecioMayor(cantidad);
    }

    public String getSubtotalFormateado() {
        return String.format("$ %,.0f COP", getSubtotal()).replace(",", ".");
    }

    public double getPesoTotal() {
        if (product == null) return 0.0;
        return product.getPesoKg() * cantidad;
    }

    public double getPesoTotalLbs() {
        return getPesoTotal() * 2.20462;
    }

    public String getPesoTotalDual() {
        return String.format(Locale.US, "%.1f kg (%.2f lbs)", getPesoTotal(), getPesoTotalLbs());
    }
}
