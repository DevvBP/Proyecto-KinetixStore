package co.kinexstore.models;

import co.kinexstore.enums.TipoPromo;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "promotions")
public class Promotion implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String codigo;

    @Column(nullable = false, length = 150)
    private String titulo;

    @Column(length = 255)
    private String subtitulo;

    @Column(name = "porcentaje_descuento")
    private double porcentajeDescuento;

    @Column(name = "descuento_fijo_cop")
    private double descuentoFijoCOP;

    @Column(name = "compra_minima_cop")
    private double compraMinimaCOP;

    @Column(name = "fecha_inicio")
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    @Column(nullable = false)
    @Builder.Default
    private boolean activa = true;

    @Column(name = "usos_restantes")
    @Builder.Default
    private int usosRestantes = 100;

    @Column(name = "imagen_banner", length = 255)
    private String imagenBanner;

    @Column(name = "cta_texto", length = 100)
    @Builder.Default
    private String ctaTexto = "Explorar Oferta";

    @Column(name = "cta_url", length = 255)
    @Builder.Default
    private String ctaUrl = "/catalogo";

    @Enumerated(EnumType.STRING)
    @Column(length = 30, nullable = false)
    @Builder.Default
    private TipoPromo tipo = TipoPromo.CUPON;

    public boolean estaVigente() {
        if (!activa) return false;
        LocalDate hoy = LocalDate.now();
        if (fechaInicio != null && hoy.isBefore(fechaInicio)) return false;
        if (fechaFin != null && hoy.isAfter(fechaFin)) return false;
        return true;
    }
}
