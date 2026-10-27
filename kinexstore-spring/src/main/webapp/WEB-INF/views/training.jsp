<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
     VISTA: training.jsp — Wizard Completo de Plan Personalizado
     GET:  /planes  (o /planes/configurar)
     POST: /planes/generar  → Auth Gate intercepta si no está logueado
     Atributos esperados:
       - erroresValidacion (List<String>)
--%>
<c:set var="pageTitle" value="Crea Tu Plan" />
<c:set var="pageDescription" value="Configura tu plan de entrenamiento personalizado. Edad, peso, objetivo, nivel y más." />
<c:set var="vistaActiva" value="training" />
<%@ include file="includes/header.jsp" %>

    <div class="max-w-3xl mx-auto px-4 md:px-8 py-16" id="section-plan">

        <!-- Header -->
        <div class="text-center mb-10">
            <span class="material-symbols-outlined text-4xl text-primary-fixed mb-3 block">fitness_center</span>
            <h1 class="font-headline-lg text-primary mb-3">Crea Tu Plan Personalizado</h1>
            <p class="font-body-md text-on-surface-variant max-w-lg mx-auto">
                Responde estas preguntas y nuestro motor generará una rutina adaptada a tu cuerpo, tu objetivo y tu estilo de vida.
            </p>
            <c:if test="${not empty sessionScope.usuarioActual}">
                <p class="mt-3 text-sm text-primary-fixed">
                    <span class="material-symbols-outlined text-[16px] align-middle">person</span>
                    Generando plan para <strong>${sessionScope.usuarioActual.nombreCompleto}</strong>
                </p>
            </c:if>
        </div>

        <!-- Auth Gate notice (si viene de un flujo sin sesión) -->
        <c:if test="${empty sessionScope.usuarioActual}">
            <div class="mb-6 p-4 border border-primary-fixed/30 bg-primary-fixed/5 rounded-DEFAULT flex items-start gap-3">
                <span class="material-symbols-outlined text-primary-fixed mt-0.5">lock</span>
                <div>
                    <p class="font-label-md text-primary mb-1">¿Ya tienes cuenta?</p>
                    <p class="font-body-md text-on-surface-variant text-sm">
                        Al dar clic en "Generar mi Plan" te pediremos crear una cuenta gratuita para guardar tu perfil y mostrarte los productos recomendados.
                        <a href="${contextPath}/login" class="text-primary-fixed underline ml-1">Iniciar sesión</a>
                    </p>
                </div>
            </div>
        </c:if>

        <!-- Errores de validación -->
        <c:if test="${not empty erroresValidacion}">
            <div class="mb-6 p-4 bg-red-900/30 border border-red-700 rounded-DEFAULT" role="alert">
                <p class="font-label-md text-red-300 mb-2 flex items-center gap-2">
                    <span class="material-symbols-outlined text-[18px]">error</span>
                    Corrige los siguientes errores:
                </p>
                <ul class="list-disc list-inside space-y-1">
                    <c:forEach var="error" items="${erroresValidacion}">
                        <li class="font-body-md text-red-300 text-sm">${error}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <!-- ============================================================
             FORMULARIO WIZARD MULTI-STEP
             ============================================================ -->
        <form action="${contextPath}/planes/generar" method="post" id="plan-form"
              class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-6 md:p-8 space-y-8">

            <!-- ---- PASO 1: Nivel de Experiencia ---- -->
            <fieldset>
                <legend class="font-headline-md text-primary mb-4 pb-2 border-b border-border-industrial w-full block">
                    <span class="text-primary-fixed font-mono mr-2">01</span> Nivel de Experiencia
                </legend>
                <div class="grid grid-cols-3 gap-3" role="radiogroup">
                    <c:forEach var="entry" items="${[['principiante','trending_up','0 – 1 año'],['intermedio','stacked_bar_chart','1 – 3 años'],['avanzado','military_tech','3+ años']]}">
                        <label class="cursor-pointer" for="nivel-${entry[0]}">
                            <input class="peer sr-only" name="nivel" id="nivel-${entry[0]}"
                                   type="radio" value="${entry[0]}"
                                   ${entry[0] == 'principiante' ? 'checked' : ''}>
                            <div class="p-3 border border-border-industrial rounded text-center
                                        peer-checked:border-primary-fixed peer-checked:bg-primary-fixed/10
                                        hover:border-outline transition-all hover:scale-105 cursor-pointer">
                                <span class="material-symbols-outlined block text-2xl mb-1 text-on-surface-variant peer-checked:text-primary-fixed">${entry[1]}</span>
                                <span class="font-label-md text-primary block capitalize">${entry[0]}</span>
                                <span class="font-label-sm text-on-surface-variant text-xs">${entry[2]}</span>
                            </div>
                        </label>
                    </c:forEach>
                </div>
            </fieldset>

            <!-- ---- PASO 2: Días por Semana ---- -->
            <fieldset>
                <legend class="font-headline-md text-primary mb-4 pb-2 border-b border-border-industrial w-full block">
                    <span class="text-primary-fixed font-mono mr-2">02</span> Días por Semana
                </legend>
                <div class="grid grid-cols-4 gap-3" role="radiogroup">
                    <c:forEach var="d" items="${[3, 4, 5, 6]}">
                        <label class="cursor-pointer" for="dias-${d}">
                            <input class="peer sr-only" name="dias" id="dias-${d}"
                                   type="radio" value="${d}" ${d == 4 ? 'checked' : ''}>
                            <div class="p-3 border border-border-industrial rounded text-center
                                        peer-checked:border-primary-fixed peer-checked:bg-primary-fixed/10
                                        hover:border-outline transition-all hover:scale-105 cursor-pointer">
                                <span class="font-headline-md text-primary block">${d}</span>
                                <span class="font-label-sm text-on-surface-variant text-xs">días</span>
                            </div>
                        </label>
                    </c:forEach>
                </div>
            </fieldset>

            <!-- ---- PASO 3: Objetivo Principal ---- -->
            <div>
                <h3 class="font-headline-md text-primary mb-4 pb-2 border-b border-border-industrial">
                    <span class="text-primary-fixed font-mono mr-2">03</span> Objetivo Principal
                </h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3" role="radiogroup">
                    <c:forEach var="obj" items="${[['HIPERTROFIA','fitness_center','Hipertrofia','Ganancia Muscular'],['FUERZA_MAXIMA','exercise','Fuerza Máxima','Levantamiento de Potencia'],['PERDIDA_GRASA','local_fire_department','Pérdida de Grasa','Definición y Cardio'],['RESISTENCIA','directions_run','Resistencia','Acondicionamiento Físico']]}">
                        <label class="cursor-pointer" for="obj-${obj[0]}">
                            <input class="peer sr-only" name="objetivo" id="obj-${obj[0]}" type="radio" value="${obj[0]}">
                            <div class="p-4 border border-border-industrial rounded flex items-center gap-3
                                        peer-checked:border-primary-fixed peer-checked:bg-primary-fixed/10
                                        hover:border-outline transition-all cursor-pointer">
                                <span class="material-symbols-outlined text-2xl text-on-surface-variant peer-checked:text-primary-fixed">${obj[1]}</span>
                                <div>
                                    <span class="font-label-md text-primary block">${obj[2]}</span>
                                    <span class="font-label-sm text-on-surface-variant text-xs">${obj[3]}</span>
                                </div>
                            </div>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <!-- ---- PASO 4: Datos Biométricos ---- -->
            <div>
                <h3 class="font-headline-md text-primary mb-4 pb-2 border-b border-border-industrial">
                    <span class="text-primary-fixed font-mono mr-2">04</span> Tu Perfil Físico
                </h3>
                <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <div>
                        <label for="edad" class="font-label-sm text-on-surface-variant block mb-1">Edad (años)</label>
                        <input type="number" id="edad" name="edad" min="14" max="80" value="25"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary rounded p-3
                                      focus:ring-2 focus:ring-primary-fixed focus:outline-none" required>
                    </div>
                    <div>
                        <label for="pesoKg" class="font-label-sm text-on-surface-variant block mb-1">Peso (kg)</label>
                        <input type="number" id="pesoKg" name="pesoKg" min="30" max="250" step="0.5" value="70"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary rounded p-3
                                      focus:ring-2 focus:ring-primary-fixed focus:outline-none" required>
                    </div>
                    <div>
                        <label for="estaturaCm" class="font-label-sm text-on-surface-variant block mb-1">Estatura (cm)</label>
                        <input type="number" id="estaturaCm" name="estaturaCm" min="120" max="230" step="0.5" value="170"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary rounded p-3
                                      focus:ring-2 focus:ring-primary-fixed focus:outline-none" required>
                    </div>
                </div>
            </div>

            <!-- ---- PASO 5: Lugar de Entrenamiento y Dieta ---- -->
            <div>
                <h3 class="font-headline-md text-primary mb-4 pb-2 border-b border-border-industrial">
                    <span class="text-primary-fixed font-mono mr-2">05</span> Entorno y Nutrición
                </h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label for="lugarEntrenamiento" class="font-label-sm text-on-surface-variant block mb-1">Lugar de Entrenamiento</label>
                        <select id="lugarEntrenamiento" name="lugarEntrenamiento"
                                class="w-full bg-[#0A0A0A] border border-border-industrial text-primary rounded p-3
                                       focus:ring-2 focus:ring-primary-fixed focus:outline-none">
                            <option value="GYM_COMERCIAL">🏋️ Gimnasio Comercial</option>
                            <option value="HOME_GYM">🏠 Home Gym / Garage</option>
                            <option value="AL_AIRE_LIBRE">🌳 Al Aire Libre / Calistenia</option>
                            <option value="CROSSFIT_BOX">⚡ CrossFit Box</option>
                        </select>
                    </div>
                    <div>
                        <label for="tipoDieta" class="font-label-sm text-on-surface-variant block mb-1">Tipo de Dieta</label>
                        <select id="tipoDieta" name="tipoDieta"
                                class="w-full bg-[#0A0A0A] border border-border-industrial text-primary rounded p-3
                                       focus:ring-2 focus:ring-primary-fixed focus:outline-none">
                            <option value="OMNIVORO">🥩 Omnívoro</option>
                            <option value="VEGETARIANO">🥗 Vegetariano</option>
                            <option value="VEGANO">🌱 Vegano</option>
                            <option value="KETO">🥑 Cetogénica / Keto</option>
                            <option value="SIN_GLUTEN">🌾 Sin Gluten</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- ---- Botón Generar ---- -->
            <button class="w-full bg-primary-fixed text-black font-label-md px-8 py-4 rounded-DEFAULT
                           hover:bg-white hover:shadow-lg hover:shadow-primary-fixed/50
                           transition-all duration-200 uppercase font-semibold tracking-wider
                           flex items-center justify-center gap-2 group"
                    type="submit"
                    id="btn-generar-plan">
                <span class="material-symbols-outlined group-hover:rotate-180 transition-transform duration-500">auto_awesome</span>
                Generar mi Plan
                <c:if test="${empty sessionScope.usuarioActual}">
                    <span class="text-xs opacity-70 ml-1">(requiere cuenta)</span>
                </c:if>
            </button>
        </form>
    </div>

<%@ include file="includes/footer.jsp" %>
