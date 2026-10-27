package co.kinexstore.models;

import co.kinexstore.enums.EstadoOrden;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entidad JPA que representa una Orden de Compra en KinexStore.
 * Mapeada a la tabla 'orders' en MySQL.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "orders")
public class Order implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_orden", unique = true, nullable = false, length = 50)
    private String numeroOrden;

    @Column(name = "cliente_nombre", nullable = false, length = 150)
    private String clienteNombre;

    @Column(name = "cliente_email", nullable = false, length = 150)
    private String clienteEmail;

    @Column(name = "cliente_telefono", length = 30)
    private String clienteTelefono;

    @Column(name = "direccion_envio", nullable = false, length = 255)
    private String direccionEnvio;

    @Column(length = 100)
    private String ciudad;

    @Column(name = "fecha_creacion", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime fechaCreacion = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    @Column(length = 30, nullable = false)
    @Builder.Default
    private EstadoOrden estado = EstadoOrden.PENDIENTE;

    @Column(nullable = false)
    private double subtotal;

    @Column(name = "costo_envio")
    private double costoEnvio;

    @Column(name = "descuento_mayorista")
    private double descuentoMayorista;

    @Column(nullable = false)
    private double total;

    @Column(name = "es_carga_pesada")
    private boolean esCargaPesada;

    @Column(length = 100)
    private String transportadora;

    @Column(name = "numero_guia", length = 100)
    private String numeroGuia;

    @Column(name = "notas_logistica", columnDefinition = "TEXT")
    private String notasLogistica;

    // ----------------------------------------------------------------
    // Métodos de negocio y formateo para vistas JSP
    // ----------------------------------------------------------------
    public String getTotalFormateado() {
        return String.format("$ %,.0f COP", total).replace(",", ".");
    }

    public String getSubtotalFormateado() {
        return String.format("$ %,.0f COP", subtotal).replace(",", ".");
    }

    public String getEnvioFormateado() {
        return String.format("$ %,.0f COP", costoEnvio).replace(",", ".");
    }

    @PrePersist
    public void prePersist() {
        if (this.fechaCreacion == null) {
            this.fechaCreacion = LocalDateTime.now();
        }
        if (this.estado == null) {
            this.estado = EstadoOrden.PENDIENTE;
        }
    }
}
