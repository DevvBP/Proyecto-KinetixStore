package co.kinexstore.enums;

/**
 * Nivel de experiencia del usuario para planes de entrenamiento.
 */
public enum NivelExperiencia {
    PRINCIPIANTE("Principiante"),
    INTERMEDIO("Intermedio"),
    AVANZADO("Avanzado");

    private final String etiqueta;

    NivelExperiencia(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public String getEtiqueta() {
        return etiqueta;
    }
}
