package co.kinexstore.models;

import co.kinexstore.enums.TipoProducto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Locale;

/**
 * Entidad JPA que representa un Producto del catálogo KinexStore.
 * Mapeada a la tabla 'products' en MySQL mediante Hibernate.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "products")
public class Product implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(nullable = false)
    private double precio;

    @Column(name = "peso_kg")
    private double pesoKg;

    @Column(length = 50)
    private String categoria;

    @Column(name = "imagen_path", length = 255)
    private String imagenPath;

    @Enumerated(EnumType.STRING)
    @Column(length = 20, nullable = false)
    private TipoProducto tipo;

    @Column(nullable = false)
    @Builder.Default
    private int stock = 50;

    @Column(nullable = false)
    @Builder.Default
    private boolean disponible = true;

    // Atributos logísticos y regulatorios
    @Column(length = 100)
    @Builder.Default
    private String dimensiones = "N/A";

    @Column(name = "descuento_mayorista_pct")
    @Builder.Default
    private double descuentoMayoristaPct = 0.0;

    @Column(name = "numero_lote", length = 50)
    @Builder.Default
    private String numeroLote = "LOT-GEN";

    @Column(name = "fecha_vencimiento")
    private LocalDate fechaVencimiento;

    @Column(name = "registro_invima", length = 50)
    @Builder.Default
    private String registroInvima = "RSA-PENDIENTE";

    // ----------------------------------------------------------------
    // Métodos de negocio y formateo para vistas JSP
    // ----------------------------------------------------------------
    public double calcularPrecioMayor(int cantidad) {
        if (cantidad >= 5) {
            return precio * cantidad * 0.85;
        } else if (cantidad >= 3) {
            return precio * cantidad * 0.92;
        }
        return precio * cantidad;
    }

    public String getPrecioFormateado() {
        return String.format("$ %,.0f COP", precio).replace(",", ".");
    }

    /**
     * Calcula el peso en libras utilizando la constante de conversión (1 kg = 2.20462 lbs).
     */
    public double getPesoLbs() {
        return pesoKg * 2.20462;
    }

    /**
     * Devuelve el peso en formato dual internacional: 'X kg (Y lbs)'
     */
    public String getPesoDual() {
        return String.format(Locale.US, "%.1f kg (%.2f lbs)", pesoKg, getPesoLbs());
    }

    public long getDiasParaVencer() {
        if (fechaVencimiento == null) return 365;
        return ChronoUnit.DAYS.between(LocalDate.now(), fechaVencimiento);
    }

    public String getEstadoCaducidadBadge() {
        long dias = getDiasParaVencer();
        if (dias <= 0) return "VENCIDO";
        if (dias <= 90) return "PROXIMO_A_VENCER";
        return "OPTIMO";
    }
}
