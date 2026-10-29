package co.kinexstore.services;

import co.kinexstore.enums.NivelExperiencia;
import co.kinexstore.enums.ObjetivoPrincipal;
import co.kinexstore.models.TrainingPlan;
import co.kinexstore.models.UserFitnessProfile;
import co.kinexstore.repositories.TrainingPlanRepository;
import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.Optional;

@Slf4j
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

    public Optional<TrainingPlan> buscarPorId(Long id) {
        return trainingPlanRepository.findById(id);
    }

    public String generarDescripcion(NivelExperiencia nivel, int dias, ObjetivoPrincipal objetivo) {
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

    /**
     * Genera un reporte PDF profesional con 3 tablas estructuradas:
     * 1) Plan de Alimentación y Macros
     * 2) Suplementación Recomendada (cómo y cuándo tomarla)
     * 3) Rutina de Entrenamiento distribuida según la elección del usuario
     */
    public byte[] exportarPlanPdf(TrainingPlan plan, UserFitnessProfile perfil) {
        log.info("Generando exportación de Plan PDF para el atleta: {}", plan.getNombreUsuario());
        Document document = new Document(PageSize.A4, 30, 30, 30, 30);
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter.getInstance(document, out);
            document.open();

            // Paleta de colores KinexStore Dark Minimal
            Color colorPrimario = new Color(15, 23, 42);      // Slate 900
            Color colorSecundario = new Color(30, 41, 59);    // Slate 800
            Color colorAcento = new Color(217, 119, 6);       // Amber 600
            Color colorBorde = new Color(226, 232, 240);      // Slate 200
            Color colorFondoFila = new Color(248, 250, 252);  // Slate 50
            Color colorTextoGris = new Color(100, 116, 139);  // Slate 500

            // Fuentes
            Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, colorPrimario);
            Font fontSubtitulo = FontFactory.getFont(FontFactory.HELVETICA, 10, colorTextoGris);
            Font fontSeccion = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, colorSecundario);
            Font fontHeaderTabla = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, Color.WHITE);
            Font fontCelda = FontFactory.getFont(FontFactory.HELVETICA, 8, colorPrimario);
            Font fontCeldaBold = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, colorPrimario);
            Font fontBadge = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, colorAcento);
            Font fontFooter = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 7, colorTextoGris);

            // ---- ENCABEZADO DEL DOCUMENTO ----
            Paragraph pMarca = new Paragraph("KINEXSTORE · HIGH PERFORMANCE FITNESS", fontBadge);
            pMarca.setSpacingAfter(2f);
            document.add(pMarca);

            Paragraph pTitulo = new Paragraph("Plan Integral de Rendimiento y Nutrición", fontTitulo);
            pTitulo.setSpacingAfter(4f);
            document.add(pTitulo);

            String fechaStr = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            Paragraph pSub = new Paragraph("Documento técnico oficial personalizado · Fecha de emisión: " + fechaStr, fontSubtitulo);
            pSub.setSpacingAfter(12f);
            document.add(pSub);

            // ---- TARJETA DE INFORMACIÓN DEL ATLETA ----
            PdfPTable infoTable = new PdfPTable(4);
            infoTable.setWidthPercentage(100);
            infoTable.setWidths(new float[]{25f, 25f, 25f, 25f});
            infoTable.setSpacingAfter(14f);

            agregarCeldaInfo(infoTable, "Atleta:", plan.getNombreUsuario() != null ? plan.getNombreUsuario() : "Cliente KinexStore", fontCeldaBold, fontCelda, colorFondoFila, colorBorde);
            agregarCeldaInfo(infoTable, "Correo:", plan.getEmailUsuario() != null ? plan.getEmailUsuario() : "atleta@kinexstore.co", fontCeldaBold, fontCelda, colorFondoFila, colorBorde);
            agregarCeldaInfo(infoTable, "Objetivo:", plan.getObjetivo() != null ? plan.getObjetivo().getEtiqueta() : "Hipertrofia", fontCeldaBold, fontCelda, colorFondoFila, colorBorde);
            agregarCeldaInfo(infoTable, "Nivel y Frecuencia:", (plan.getNivel() != null ? plan.getNivel().getEtiqueta() : "Intermedio") + " · " + plan.getDiasPorSemana() + " días/sem", fontCeldaBold, fontCelda, colorFondoFila, colorBorde);

            if (perfil != null) {
                agregarCeldaInfo(infoTable, "Peso Actual:", perfil.getPesoKg() + " kg (" + Math.round(perfil.getPesoKg() * 2.20462) + " lbs)", fontCeldaBold, fontCelda, colorFondoFila, colorBorde);
                agregarCeldaInfo(infoTable, "Estatura / Edad:", perfil.getEstaturaCm() + " cm · " + perfil.getEdad() + " años", fontCeldaBold, fontCelda, colorFondoFila, colorBorde);
                agregarCeldaInfo(infoTable, "Lugar de Entrenamiento:", perfil.getLugarEntrenamiento() != null ? perfil.getLugarEntrenamiento().getEtiqueta() : "Gimnasio Comercial", fontCeldaBold, fontCelda, colorFondoFila, colorBorde);
                agregarCeldaInfo(infoTable, "Preferencia de Dieta:", perfil.getTipoDieta() != null ? perfil.getTipoDieta().getEtiqueta() : "Omnívora Equilibrada", fontCeldaBold, fontCelda, colorFondoFila, colorBorde);
            }
            document.add(infoTable);

            // ==============================================================
            // TABLA 1: PLAN DE ALIMENTACIÓN Y MACROS
            // ==============================================================
            Paragraph sec1 = new Paragraph("1. Plan de Alimentación y Distribución de Macronutrientes", fontSeccion);
            sec1.setSpacingBefore(6f);
            sec1.setSpacingAfter(6f);
            document.add(sec1);

            PdfPTable tMacros = new PdfPTable(6);
            tMacros.setWidthPercentage(100);
            tMacros.setWidths(new float[]{18f, 38f, 11f, 11f, 11f, 11f});
            tMacros.setSpacingAfter(14f);

            agregarHeaderTabla(tMacros, new String[]{"Comida / Horario", "Alimentos Sugeridos", "Calorías", "Proteína", "Carbos", "Grasas"}, fontHeaderTabla, colorPrimario);

            boolean esFilaPar = false;
            esFilaPar = agregarFilaMacros(tMacros, "Desayuno (07:30)", "Tortilla de 3 claras + 1 huevo entero, avena en hojuelas (70g), frutos rojos y nueces.", "520 kcal", "34g", "58g", "16g", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            esFilaPar = agregarFilaMacros(tMacros, "Media Mañana (10:30)", "Batido Whey Protein Isolate KinexStore, 1 manzana verde y 20g de almendras.", "310 kcal", "28g", "25g", "10g", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            esFilaPar = agregarFilaMacros(tMacros, "Almuerzo (13:30)", "Pechuga de pollo a la plancha (180g), arroz jazmín (150g pesado cocido), aguacate y ensalada.", "680 kcal", "48g", "72g", "18g", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            esFilaPar = agregarFilaMacros(tMacros, "Pre-Entreno (16:30)", "Tortitas de arroz inflado (3 uds) con crema de maní 100% natural y 1 plátano maduro.", "340 kcal", "10g", "52g", "12g", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            esFilaPar = agregarFilaMacros(tMacros, "Cena (20:30)", "Filete de salmón / lomo de atún (170g), batata al horno (160g) y espárragos al vapor.", "590 kcal", "42g", "46g", "19g", fontCelda, esFilaPar, colorFondoFila, colorBorde);

            // Fila Totalizadora
            PdfPCell cTotal = new PdfPCell(new Phrase("TOTALES DIARIOS ESTIMADOS", fontCeldaBold));
            cTotal.setColspan(2);
            cTotal.setBackgroundColor(new Color(241, 245, 249));
            cTotal.setPadding(5f);
            cTotal.setBorderColor(colorBorde);
            tMacros.addCell(cTotal);

            agregarCeldaTotal(tMacros, "2.440 kcal", fontCeldaBold, colorBorde);
            agregarCeldaTotal(tMacros, "162g", fontCeldaBold, colorBorde);
            agregarCeldaTotal(tMacros, "253g", fontCeldaBold, colorBorde);
            agregarCeldaTotal(tMacros, "75g", fontCeldaBold, colorBorde);

            document.add(tMacros);

            // ==============================================================
            // TABLA 2: PROTOCOLO DE SUPLEMENTACIÓN RECOMENDADA
            // ==============================================================
            Paragraph sec2 = new Paragraph("2. Protocolo de Suplementación Recomendada", fontSeccion);
            sec2.setSpacingBefore(6f);
            sec2.setSpacingAfter(6f);
            document.add(sec2);

            PdfPTable tSupl = new PdfPTable(4);
            tSupl.setWidthPercentage(100);
            tSupl.setWidths(new float[]{28f, 18f, 22f, 32f});
            tSupl.setSpacingAfter(14f);

            agregarHeaderTabla(tSupl, new String[]{"Suplemento Oficial", "Dosis Diaria", "Momento de Toma (Timing)", "Instrucciones y Beneficio Clínico"}, fontHeaderTabla, colorPrimario);

            esFilaPar = false;
            esFilaPar = agregarFilaSupl(tSupl, "Creatina Monohidratada Creapure®", "5 g (1 scoop)", "Post-entreno o mañana", "Tomar a diario con abundante agua o zumo. Aumenta la fosfocreatina muscular para fuerza y volumen.", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            esFilaPar = agregarFilaSupl(tSupl, "Whey Protein Isolate 100% CFM", "30 g (1 scoop)", "Inmediato post-entreno", "Disolver en 250ml de agua fría. Máxima tasa de síntesis proteica con cero azúcares añadidos.", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            esFilaPar = agregarFilaSupl(tSupl, "Pre-Workout Nootrópico Focus", "15 g (1 scoop)", "25 min antes de entrenar", "Tomar en días pesados. Potencia vasodilatación (óxido nítrico) y enfoque sin taquicardia.", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            esFilaPar = agregarFilaSupl(tSupl, "BCAA + Electrolitos 4:1:1", "10 g diluidos", "Intra-entrenamiento", "Disolver en botella de 500ml. Previene fatiga central y mantiene balance electrolítico celular.", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            esFilaPar = agregarFilaSupl(tSupl, "Omega 3 Ultra Puro EPA/DHA", "2 cápsulas (2000mg)", "Con el almuerzo principal", "Consumir junto a grasas saludables. Control inflamatorio articular y soporte cardiovascular.", fontCelda, esFilaPar, colorFondoFila, colorBorde);

            document.add(tSupl);

            // ==============================================================
            // TABLA 3: RUTINA DE ENTRENAMIENTO DISTRIBUIDA
            // ==============================================================
            Paragraph sec3 = new Paragraph("3. Rutina de Entrenamiento Semanal (" + plan.getDiasPorSemana() + " Días)", fontSeccion);
            sec3.setSpacingBefore(6f);
            sec3.setSpacingAfter(6f);
            document.add(sec3);

            PdfPTable tRutina = new PdfPTable(5);
            tRutina.setWidthPercentage(100);
            tRutina.setWidths(new float[]{22f, 36f, 14f, 14f, 14f});
            tRutina.setSpacingAfter(14f);

            agregarHeaderTabla(tRutina, new String[]{"Día / Grupo Muscular", "Ejercicios Principales", "Series x Reps", "RPE / Esfuerzo", "Descanso"}, fontHeaderTabla, colorPrimario);

            esFilaPar = false;
            int dias = plan.getDiasPorSemana();
            if (dias <= 3) {
                esFilaPar = agregarFilaRutina(tRutina, "Día 1: Pecho, Espalda & Core", "Press Banca Plano + Jalón al Pecho Pro + Fondos + Plancha Abdominal", "4 x 8-10", "RPE 8.0", "90 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 2: Pierna Completa & Gemelos", "Sentadilla Barra Libre + Prensa 45° + Peso Muerto Rumano + Elevaciones Gemelos", "4 x 6-8", "RPE 8.5", "120 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 3: Hombros, Brazos & MetCon", "Press Militar Mancuernas + Dominadas Asistidas + Curl Barra Z + Tríceps Polea", "3 x 10-12", "RPE 8.0", "75 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            } else if (dias == 4) {
                esFilaPar = agregarFilaRutina(tRutina, "Día 1: Torso Pesado (Fuerza)", "Press Banca Barra + Remo con Barra + Press Militar + Jalón Dorsal Agarre Neutro", "4 x 6-8", "RPE 8.5", "120 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 2: Pierna Cuádriceps & Core", "Sentadilla Trasera + Prensa 45° + Extensiones de Pierna + Elevación de Piernas Colgado", "4 x 8-10", "RPE 8.0", "90 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 3: Torso Hipertrofia", "Press Inclinado Mancuernas + Remo Gironda Polea + Elevaciones Laterales + Bíceps/Tríceps Superset", "3 x 10-12", "RPE 8.0", "75 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 4: Pierna Posterior & Glúteo", "Peso Muerto Convencional + Hip Thrust Barra + Curl Femoral Tumbado + Gemelos de Pie", "4 x 8-10", "RPE 8.5", "90 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            } else {
                esFilaPar = agregarFilaRutina(tRutina, "Día 1: Push (Empuje - Pecho/Hombro/Tríceps)", "Press Banca Inclinado + Chest Press Máquina + Press Militar + Tríceps Cuerda", "4 x 8-10", "RPE 8.5", "90 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 2: Pull (Tracción - Espalda/Bíceps)", "Dominadas Lastradas + Remo con Barra T + Jalón al Pecho + Curl Martillo", "4 x 8-10", "RPE 8.5", "90 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 3: Legs (Pierna Enfoque Cuádriceps)", "Sentadilla Frontal + Prensa 45° + Búlgaras con Mancuernas + Gemelos Prensa", "4 x 8-10", "RPE 8.5", "100 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 4: Push / Pull Secundario", "Fondos en Paralelas + Remo con Mancuerna + Cruces de Polea + Curl Concentrado", "3 x 10-12", "RPE 8.0", "75 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
                esFilaPar = agregarFilaRutina(tRutina, "Día 5: Legs (Cadena Posterior & Glúteos)", "Peso Muerto Rumano + Hip Thrust Pesado + Curl Isquios + Abductores en Polea", "4 x 8-10", "RPE 8.5", "90 seg", fontCelda, esFilaPar, colorFondoFila, colorBorde);
            }

            document.add(tRutina);

            // ---- PIE DE PÁGINA INSTITUCIONAL ----
            Paragraph pAviso = new Paragraph(
                "Aviso Legal y de Salud: Este plan ha sido formulado mediante algoritmos biométricos y validado por la suite deportiva de KinexStore. " +
                "Recomendamos consultar a un profesional médico o nutricionista colegiado antes de iniciar cualquier protocolo de alta exigencia.",
                fontFooter
            );
            pAviso.setSpacingBefore(10f);
            document.add(pAviso);

            document.close();
            log.info("PDF de Plan generado con éxito (tamaño: {} bytes)", out.size());
            return out.toByteArray();

        } catch (DocumentException e) {
            log.error("Error al construir el documento PDF de plan: {}", e.getMessage(), e);
            throw new RuntimeException("Error en la generación del PDF: " + e.getMessage(), e);
        }
    }

    // ---- MÉTODOS AUXILIARES DE ESTILIZADO PDF ----

    private void agregarCeldaInfo(PdfPTable table, String etiqueta, String valor,
                                 Font fontBold, Font fontNormal, Color bg, Color border) {
        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(bg);
        cell.setBorderColor(border);
        cell.setPadding(5f);

        Paragraph p = new Paragraph();
        p.add(new Phrase(etiqueta + " ", fontBold));
        p.add(new Phrase(valor, fontNormal));
        cell.addElement(p);
        table.addCell(cell);
    }

    private void agregarHeaderTabla(PdfPTable table, String[] encabezados, Font font, Color bg) {
        for (String h : encabezados) {
            PdfPCell cell = new PdfPCell(new Phrase(h, font));
            cell.setBackgroundColor(bg);
            cell.setPadding(5f);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
            table.addCell(cell);
        }
    }

    private boolean agregarFilaMacros(PdfPTable table, String comida, String alimentos,
                                     String cal, String prot, String carb, String grasas,
                                     Font font, boolean esPar, Color bgAlt, Color border) {
        Color bg = esPar ? bgAlt : Color.WHITE;
        agregarCeldaDato(table, comida, font, bg, border, Element.ALIGN_LEFT);
        agregarCeldaDato(table, alimentos, font, bg, border, Element.ALIGN_LEFT);
        agregarCeldaDato(table, cal, font, bg, border, Element.ALIGN_CENTER);
        agregarCeldaDato(table, prot, font, bg, border, Element.ALIGN_CENTER);
        agregarCeldaDato(table, carb, font, bg, border, Element.ALIGN_CENTER);
        agregarCeldaDato(table, grasas, font, bg, border, Element.ALIGN_CENTER);
        return !esPar;
    }

    private boolean agregarFilaSupl(PdfPTable table, String nombre, String dosis, String timing, String detalle,
                                   Font font, boolean esPar, Color bgAlt, Color border) {
        Color bg = esPar ? bgAlt : Color.WHITE;
        agregarCeldaDato(table, nombre, font, bg, border, Element.ALIGN_LEFT);
        agregarCeldaDato(table, dosis, font, bg, border, Element.ALIGN_CENTER);
        agregarCeldaDato(table, timing, font, bg, border, Element.ALIGN_CENTER);
        agregarCeldaDato(table, detalle, font, bg, border, Element.ALIGN_LEFT);
        return !esPar;
    }

    private boolean agregarFilaRutina(PdfPTable table, String dia, String ejercicios, String series,
                                     String rpe, String descanso, Font font, boolean esPar, Color bgAlt, Color border) {
        Color bg = esPar ? bgAlt : Color.WHITE;
        agregarCeldaDato(table, dia, font, bg, border, Element.ALIGN_LEFT);
        agregarCeldaDato(table, ejercicios, font, bg, border, Element.ALIGN_LEFT);
        agregarCeldaDato(table, series, font, bg, border, Element.ALIGN_CENTER);
        agregarCeldaDato(table, rpe, font, bg, border, Element.ALIGN_CENTER);
        agregarCeldaDato(table, descanso, font, bg, border, Element.ALIGN_CENTER);
        return !esPar;
    }

    private void agregarCeldaDato(PdfPTable table, String texto, Font font, Color bg, Color border, int align) {
        PdfPCell cell = new PdfPCell(new Phrase(texto, font));
        cell.setBackgroundColor(bg);
        cell.setBorderColor(border);
        cell.setPadding(4f);
        cell.setHorizontalAlignment(align);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    }

    private void agregarCeldaTotal(PdfPTable table, String texto, Font font, Color border) {
        PdfPCell cell = new PdfPCell(new Phrase(texto, font));
        cell.setBackgroundColor(new Color(241, 245, 249));
        cell.setBorderColor(border);
        cell.setPadding(5f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    }
}
