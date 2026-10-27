package co.kinexstore.enums;

/**
 * Lugar principal de entrenamiento del atleta.
 */
public enum LugarEntrenamiento {
    GYM_COMERCIAL("Gimnasio Comercial"),
    HOME_GYM("Home Gym / Garage"),
    AL_AIRE_LIBRE("Al Aire Libre / Calistenia"),
    CROSSFIT_BOX("CrossFit Box");

    private final String etiqueta;

    LugarEntrenamiento(String etiqueta) { this.etiqueta = etiqueta; }

    public String getEtiqueta() { return etiqueta; }
}
