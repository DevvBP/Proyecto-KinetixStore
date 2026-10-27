package co.kinexstore.enums;

/**
 * Tipo de dieta o restricción alimentaria del atleta.
 */
public enum TipoDieta {
    OMNIVORO("Omnívoro"),
    VEGETARIANO("Vegetariano"),
    VEGANO("Vegano"),
    KETO("Cetogénica / Keto"),
    SIN_GLUTEN("Sin Gluten");

    private final String etiqueta;

    TipoDieta(String etiqueta) { this.etiqueta = etiqueta; }

    public String getEtiqueta() { return etiqueta; }
}
