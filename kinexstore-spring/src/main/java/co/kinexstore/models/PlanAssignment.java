package co.kinexstore.models;

import co.kinexstore.enums.EstadoPlan;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "plan_assignments")
public class PlanAssignment implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "cliente_nombre", nullable = false, length = 150)
    private String clienteNombre;

    @Column(name = "cliente_email", nullable = false, length = 150)
    private String clienteEmail;

    @Column(name = "cliente_telefono", length = 30)
    private String clienteTelefono;

    @Column(length = 50)
    private String nivel;

    @Column(name = "dias_por_semana")
    private int diasPorSemana;

    @Column(length = 100)
    private String objetivo;

    @Column(name = "fecha_solicitud", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime fechaSolicitud = LocalDateTime.now();

    @Column(name = "fecha_entrega")
    private LocalDateTime fechaEntrega;

    @Enumerated(EnumType.STRING)
    @Column(length = 30, nullable = false)
    @Builder.Default
    private EstadoPlan estado = EstadoPlan.PENDIENTE;

    @Column(name = "entrenador_asignado", length = 150)
    private String entrenadorAsignado;

    @Column(name = "archivo_pdf_nombre", length = 255)
    private String archivoPdfNombre;

    @Column(name = "rutina_detalle_texto", columnDefinition = "TEXT")
    private String rutinaDetalleTexto;

    @Column(name = "dieta_detalle_texto", columnDefinition = "TEXT")
    private String dietaDetalleTexto;

    @Column(name = "suplementos_recomendados", columnDefinition = "TEXT")
    private String suplementosRecomendados;

    @Column(name = "precio_pagado", nullable = false)
    private double precioPagado;

    public String getPrecioFormateado() {
        return String.format("$ %,.0f COP", precioPagado).replace(",", ".");
    }

    @PrePersist
    public void prePersist() {
        if (this.fechaSolicitud == null) {
            this.fechaSolicitud = LocalDateTime.now();
        }
        if (this.estado == null) {
            this.estado = EstadoPlan.PENDIENTE;
        }
    }
}
