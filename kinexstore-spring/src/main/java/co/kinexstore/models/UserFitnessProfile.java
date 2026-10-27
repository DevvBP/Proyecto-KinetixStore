package co.kinexstore.models;

import co.kinexstore.enums.LugarEntrenamiento;
import co.kinexstore.enums.ObjetivoPrincipal;
import co.kinexstore.enums.NivelExperiencia;
import co.kinexstore.enums.TipoDieta;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Perfil físico y deportivo de un atleta registrado en KinexStore.
 * Se relaciona One-to-One con User y alimenta el motor de planes
 * personalizados y recomendaciones de cross-selling.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "user_fitness_profiles")
public class UserFitnessProfile implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Relación 1:1 con el usuario propietario del perfil. */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    // ----------------------------------------------------------------
    // Datos biométricos
    // ----------------------------------------------------------------
    /** Edad en años. */
    @Column(nullable = false)
    private int edad;

    /** Peso corporal actual en kilogramos. */
    @Column(name = "peso_kg", nullable = false)
    private double pesoKg;

    /** Estatura en centímetros. */
    @Column(name = "estatura_cm", nullable = false)
    private double estaturaCm;

    // ----------------------------------------------------------------
    // Datos de entrenamiento
    // ----------------------------------------------------------------
    /** Objetivo físico principal del atleta. */
    @Enumerated(EnumType.STRING)
    @Column(name = "objetivo", length = 30, nullable = false)
    private ObjetivoPrincipal objetivo;

    /** Nivel de experiencia declarado. */
    @Enumerated(EnumType.STRING)
    @Column(name = "nivel_experiencia", length = 30, nullable = false)
    private NivelExperiencia nivelExperiencia;

    /** Días disponibles por semana para entrenar (3-6). */
    @Column(name = "dias_disponibles", nullable = false)
    @Builder.Default
    private int diasDisponibles = 4;

    /** Lugar principal de entrenamiento. */
    @Enumerated(EnumType.STRING)
    @Column(name = "lugar_entrenamiento", length = 30, nullable = false)
    @Builder.Default
    private LugarEntrenamiento lugarEntrenamiento = LugarEntrenamiento.GYM_COMERCIAL;

    // ----------------------------------------------------------------
    // Datos nutricionales
    // ----------------------------------------------------------------
    /** Tipo de dieta o restricción alimentaria. */
    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_dieta", length = 30, nullable = false)
    @Builder.Default
    private TipoDieta tipoDieta = TipoDieta.OMNIVORO;

    /** Fecha y hora en que se completó el perfil. */
    @Column(name = "fecha_creacion", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime fechaCreacion = LocalDateTime.now();

    // ----------------------------------------------------------------
    // Métodos de negocio
    // ----------------------------------------------------------------

    /** Retorna el IMC calculado con 2 decimales. */
    public double getImc() {
        double estM = estaturaCm / 100.0;
        return Math.round((pesoKg / (estM * estM)) * 100.0) / 100.0;
    }

    /** Clasificación textual del IMC. */
    public String getClasificacionImc() {
        double imc = getImc();
        if (imc < 18.5) return "Bajo peso";
        if (imc < 25.0) return "Normal";
        if (imc < 30.0) return "Sobrepeso";
        return "Obesidad";
    }

    /** Peso en libras (1 kg = 2.20462 lbs). */
    public double getPesoLbs() {
        return pesoKg * 2.20462;
    }

    /** Peso en formato dual: 'X kg (Y lbs)'. */
    public String getPesoDual() {
        return String.format("%.1f kg (%.2f lbs)", pesoKg, getPesoLbs());
    }

    @PrePersist
    public void prePersist() {
        if (this.fechaCreacion == null) {
            this.fechaCreacion = LocalDateTime.now();
        }
    }
}
