package co.kinexstore.models;

import co.kinexstore.enums.NivelExperiencia;
import co.kinexstore.enums.ObjetivoPrincipal;
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
@Table(name = "training_plans")
public class TrainingPlan implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private NivelExperiencia nivel;

    @Column(name = "dias_por_semana", nullable = false)
    private int diasPorSemana;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ObjetivoPrincipal objetivo;

    @Column(name = "nombre_usuario", length = 150)
    private String nombreUsuario;

    @Column(name = "email_usuario", length = 150)
    private String emailUsuario;

    @Column(name = "fecha_creacion", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime fechaCreacion = LocalDateTime.now();

    @Column(name = "descripcion_generada", columnDefinition = "TEXT")
    private String descripcionGenerada;

    public String generarResumen() {
        return String.format(
            "Plan %s para %s · %d días/semana · Objetivo: %s",
            nivel != null ? nivel.getEtiqueta() : "",
            nombreUsuario != null ? nombreUsuario : "Atleta",
            diasPorSemana,
            objetivo != null ? objetivo.getEtiqueta() : ""
        );
    }

    @PrePersist
    public void prePersist() {
        if (this.fechaCreacion == null) {
            this.fechaCreacion = LocalDateTime.now();
        }
    }
}
