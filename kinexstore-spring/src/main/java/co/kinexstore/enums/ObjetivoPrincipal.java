package co.kinexstore.enums;

/**
 * Objetivo físico principal del usuario para planes personalizados.
 */
public enum ObjetivoPrincipal {
    HIPERTROFIA("Hipertrofia (Ganancia Muscular)"),
    FUERZA_MAXIMA("Fuerza Máxima"),
    PERDIDA_GRASA("Pérdida de Grasa"),
    RESISTENCIA("Resistencia / Acondicionamiento");

    private final String etiqueta;

    ObjetivoPrincipal(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public String getEtiqueta() {
        return etiqueta;
    }
}
