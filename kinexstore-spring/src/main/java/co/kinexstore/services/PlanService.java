package co.kinexstore.services;

import co.kinexstore.enums.NivelExperiencia;
import co.kinexstore.enums.ObjetivoPrincipal;
import co.kinexstore.models.TrainingPlan;
import co.kinexstore.repositories.TrainingPlanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class PlanService {

    private final TrainingPlanRepository trainingPlanRepository;

    private static final Map<ObjetivoPrincipal, String[]> SUPLEMENTOS_RECOMENDADOS = Map.of(
        ObjetivoPrincipal.HIPERTROFIA,   new String[]{"Whey Protein Isolate", "Creatina Monohidratada", "Mass Gainer Premium"},
        ObjetivoPrincipal.FUERZA_MAXIMA, new String[]{"Creatina Monohidratada", "BCAA Complex", "Pre-Workout Nootrópico"},
        ObjetivoPrincipal.PERDIDA_GRASA, new String[]{"Whey Protein Isolate", "BCAA Complex", "Omega 3 Alta Concentración"},
        ObjetivoPrincipal.RESISTENCIA,   new String[]{"BCAA Complex + Electrolitos", "Omega 3", "Pre-Workout Nootrópico"}
    );

    @Transactional
    public TrainingPlan crearPlan(NivelExperiencia nivel, int dias,
                                  ObjetivoPrincipal objetivo,
                                  String nombreUsuario, String email) {
        TrainingPlan plan = TrainingPlan.builder()
                .nivel(nivel)
                .diasPorSemana(dias)
                .objetivo(objetivo)
                .nombreUsuario(nombreUsuario)
                .emailUsuario(email)
                .descripcionGenerada(generarDescripcion(nivel, dias, objetivo))
                .build();
        return trainingPlanRepository.save(plan);
    }

    private String generarDescripcion(NivelExperiencia nivel, int dias, ObjetivoPrincipal objetivo) {
        String frecuencia = switch (dias) {
            case 3 -> "Full Body 3 días";
            case 4 -> "Upper/Lower 4 días";
            case 5 -> "PPL (Push/Pull/Legs) 5 días";
            case 6 -> "PPL 6 días (Alta frecuencia)";
            default -> dias + " días/semana";
        };

        String[] supls = SUPLEMENTOS_RECOMENDADOS.getOrDefault(objetivo, new String[]{});
        String suplStr = String.join(", ", supls);

        return String.format(
            "PLAN %s · NIVEL %s · %s%n%n" +
            "Objetivo: %s%n" +
            "Frecuencia recomendada: %s%n" +
            "Suplementación sugerida: %s%n%n" +
            "Un especialista KinexStore revisará este plan y se pondrá en contacto contigo en las próximas 24 horas.",
            objetivo != null ? objetivo.getEtiqueta().toUpperCase() : "",
            nivel != null ? nivel.getEtiqueta().toUpperCase() : "",
            frecuencia,
            objetivo != null ? objetivo.getEtiqueta() : "",
            frecuencia,
            suplStr
        );
    }

    public String[] getSuplementosRecomendados(ObjetivoPrincipal objetivo) {
        return SUPLEMENTOS_RECOMENDADOS.getOrDefault(objetivo, new String[]{});
    }
}
