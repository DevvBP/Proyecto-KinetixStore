package co.kinexstore.services;

import co.kinexstore.enums.LugarEntrenamiento;
import co.kinexstore.enums.NivelExperiencia;
import co.kinexstore.enums.ObjetivoPrincipal;
import co.kinexstore.enums.TipoDieta;
import co.kinexstore.models.TrainingPlan;
import co.kinexstore.models.User;
import co.kinexstore.models.UserFitnessProfile;
import co.kinexstore.repositories.TrainingPlanRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Unidad 10: Pruebas Unitarias de PlanService y Generación de PDF")
class PlanServiceTest {

    @Mock
    private TrainingPlanRepository trainingPlanRepository;

    @InjectMocks
    private PlanService planService;

    @Test
    @DisplayName("Debe crear y persistir un plan de entrenamiento con su descripción generada")
    void testCrearPlanHipertrofia() {
        TrainingPlan mockGuardado = TrainingPlan.builder()
                .id(10L)
                .nivel(NivelExperiencia.AVANZADO)
                .diasPorSemana(5)
                .objetivo(ObjetivoPrincipal.HIPERTROFIA)
                .nombreUsuario("Atleta Pro")
                .emailUsuario("atleta@kinexstore.co")
                .descripcionGenerada("PLAN HIPERTROFIA · NIVEL AVANZADO")
                .build();

        when(trainingPlanRepository.save(any(TrainingPlan.class))).thenReturn(mockGuardado);

        TrainingPlan resultado = planService.crearPlan(
                NivelExperiencia.AVANZADO,
                5,
                ObjetivoPrincipal.HIPERTROFIA,
                "Atleta Pro",
                "atleta@kinexstore.co"
        );

        assertNotNull(resultado);
        assertEquals(10L, resultado.getId());
        assertEquals(NivelExperiencia.AVANZADO, resultado.getNivel());
        assertEquals(5, resultado.getDiasPorSemana());
        verify(trainingPlanRepository, times(1)).save(any(TrainingPlan.class));
    }

    @Test
    @DisplayName("Debe generar descripción coherente con frecuencia de días y objetivo físico")
    void testGenerarDescripcionSegunDiasYNivel() {
        String descPPL = planService.generarDescripcion(NivelExperiencia.INTERMEDIO, 5, ObjetivoPrincipal.HIPERTROFIA);
        assertTrue(descPPL.contains("PPL (Push/Pull/Legs) 5 días"));
        assertTrue(descPPL.contains("HIPERTROFIA"));

        String descUpperLower = planService.generarDescripcion(NivelExperiencia.PRINCIPIANTE, 4, ObjetivoPrincipal.FUERZA_MAXIMA);
        assertTrue(descUpperLower.contains("Upper/Lower 4 días"));
        assertTrue(descUpperLower.contains("FUERZA"));
    }

    @Test
    @DisplayName("Debe generar un binario PDF válido que inicie con la cabecera estándar %PDF-")
    void testGenerarPdfRetornaBytesValidosYNoVacios() {
        TrainingPlan plan = TrainingPlan.builder()
                .id(1L)
                .nivel(NivelExperiencia.INTERMEDIO)
                .diasPorSemana(4)
                .objetivo(ObjetivoPrincipal.HIPERTROFIA)
                .nombreUsuario("Carlos Gómez")
                .emailUsuario("carlos.gomez@gmail.com")
                .descripcionGenerada("Plan personalizado")
                .build();

        User usuario = User.builder().id(1L).nombre("Carlos").apellido("Gómez").email("carlos.gomez@gmail.com").build();
        UserFitnessProfile perfil = UserFitnessProfile.builder()
                .user(usuario)
                .edad(28)
                .pesoKg(75.5)
                .estaturaCm(178.0)
                .lugarEntrenamiento(LugarEntrenamiento.GYM_COMERCIAL)
                .tipoDieta(TipoDieta.OMNIVORO)
                .build();

        byte[] pdfBytes = planService.exportarPlanPdf(plan, perfil);

        assertNotNull(pdfBytes);
        assertTrue(pdfBytes.length > 1000, "El PDF generado debe contener tablas y un tamaño representativo");

        // Verificación de los bytes mágicos de un archivo PDF válido: %PDF-
        String magicHeader = new String(pdfBytes, 0, 5, StandardCharsets.US_ASCII);
        assertEquals("%PDF-", magicHeader, "El encabezado del flujo binario debe ser un documento PDF legítimo");
    }
}

