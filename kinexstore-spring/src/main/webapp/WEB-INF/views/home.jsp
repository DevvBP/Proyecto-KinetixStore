<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
     VISTA: home.jsp
     Acción: ?accion=home
     Secciones: Hero (video), Goals Grid, Bento Categories, Promo Banner
--%>
<c:set var="pageTitle" value="Inicio" />
<c:set var="pageDescription" value="Equipamiento de élite y suplementación de precisión para atletas que exigen resultados." />
<%@ include file="includes/header.jsp" %>

    <!-- ================================================================
         SECCIÓN 1: HERO (Video de fondo rotativo)
         Mockup F01: Capturar hero completo con texto, botón y video de fondo
         ================================================================ -->
    <section class="relative min-h-[80vh] flex items-center w-full overflow-hidden border-b border-border-industrial"
             id="section-hero" aria-labelledby="hero-heading">
        <div class="absolute inset-0 z-0 bg-[#0A0A0A]" id="hero-bg-stage">
            <video class="hero-bg-video active" autoplay muted loop playsinline
                   preload="auto" poster="${contextPath}/assets/img/bento-pesada.jpg"
                   aria-hidden="true"></video>
            <video class="hero-bg-video" autoplay muted loop playsinline
                   preload="none" aria-hidden="true"></video>
            <div class="absolute inset-0 bg-gradient-to-t from-[#0A0A0A] via-[#0A0A0A]/80 to-transparent"></div>
            <div class="absolute inset-0 bg-gradient-to-r from-[#0A0A0A] via-transparent to-transparent"></div>
        </div>

        <div class="relative z-10 w-full px-margin-mobile md:px-margin-desktop max-w-container-max mx-auto py-24">
            <div class="max-w-3xl">
                <div class="inline-flex items-center gap-2 px-3 py-1 bg-surface-charcoal border border-border-industrial rounded-DEFAULT mb-6 hover:border-primary-fixed transition-colors">
                    <span class="w-2 h-2 rounded-full bg-primary-fixed animate-pulse"></span>
                    <span class="font-label-sm text-label-sm text-on-surface-variant uppercase tracking-widest">Nueva Colección Pro</span>
                </div>
                <h1 id="hero-heading" class="font-display-lg text-headline-lg-mobile md:text-display-lg text-primary mb-6 uppercase tracking-tight drop-shadow-lg hover:text-primary-fixed transition-colors duration-500">
                    EQUIPA TU RENDIMIENTO.
                </h1>
                <p class="font-body-lg text-body-lg text-on-surface-variant mb-10 max-w-2xl">
                    Equipamiento de élite y suplementación de precisión bajo supervisión experta.
                    Diseñado para atletas que exigen resultados técnicos medibles.
                </p>
                <a href="${contextPath}/app?accion=listarEquipamiento"
                   class="bg-primary-fixed text-black font-label-md text-label-md px-8 py-4 rounded-DEFAULT hover:bg-white hover:shadow-lg hover:shadow-primary-fixed/50 transition-all duration-200 uppercase inline-flex items-center justify-center gap-2 group"
                   id="hero-cta">
                    Explorar Equipo
                    <span class="material-symbols-outlined group-hover:translate-x-1 transition-transform">arrow_forward</span>
                </a>
            </div>
        </div>
    </section>

    <!-- ================================================================
         SECCIÓN 2: GOALS GRID (Selección de Objetivo)
         Mockup F02: Capturar la grilla de 4 tarjetas de objetivos
         ================================================================ -->
    <section class="py-24 px-margin-mobile md:px-margin-desktop bg-[#0A0A0A] border-b border-border-industrial"
             id="section-goals" aria-labelledby="goals-heading">
        <div class="max-w-container-max mx-auto">
            <div class="mb-12">
                <h2 id="goals-heading" class="font-headline-md text-headline-md text-primary mb-2">Selecciona tu Objetivo</h2>
                <p class="font-body-md text-body-md text-on-surface-variant">Rutas optimizadas para cada disciplina.</p>
            </div>
            <div class="grid grid-cols-2 lg:grid-cols-4 gap-gutter">

                <!-- Goal: Fuerza -->
                <a class="group relative bg-surface-charcoal border border-border-industrial rounded-DEFAULT overflow-hidden
                          hover:border-primary-fixed transition-all duration-300 flex flex-col h-48 md:h-64 product-card"
                   href="${contextPath}/app?accion=listarEquipamiento" id="goal-fuerza">
                    <div class="absolute inset-0 z-0">
                        <div class="absolute inset-0 bg-cover bg-center opacity-20 group-hover:opacity-40 transition-opacity duration-500
                                    mix-blend-luminosity grayscale group-hover:grayscale-0 product-image"
                             style="background-image: url('${contextPath}/assets/img/goal-fuerza.jpg')" role="img" aria-label="Fuerza"></div>
                        <div class="absolute inset-0 bg-gradient-to-t from-[#1A1A1A] to-transparent"></div>
                    </div>
                    <div class="relative z-10 flex-grow p-6 flex flex-col justify-between">
                        <div class="w-10 h-10 rounded-full bg-surface-container-highest border border-border-industrial flex items-center justify-center
                                    group-hover:bg-primary-fixed group-hover:text-black group-hover:scale-110 transition-all">
                            <span class="material-symbols-outlined">fitness_center</span>
                        </div>
                        <div>
                            <h3 class="font-label-md text-label-md text-primary uppercase mb-1">Fuerza</h3>
                            <div class="w-0 h-px bg-primary-fixed group-hover:w-full transition-all duration-300"></div>
                        </div>
                    </div>
                </a>

                <!-- Goal: Cardio -->
                <a class="group relative bg-surface-charcoal border border-border-industrial rounded-DEFAULT overflow-hidden
                          hover:border-primary-fixed transition-all duration-300 flex flex-col h-48 md:h-64 product-card"
                   href="${contextPath}/app?accion=listarEquipamiento" id="goal-cardio">
                    <div class="absolute inset-0 z-0">
                        <div class="absolute inset-0 bg-cover bg-center opacity-20 group-hover:opacity-40 transition-opacity duration-500
                                    mix-blend-luminosity grayscale group-hover:grayscale-0 product-image"
                             style="background-image: url('${contextPath}/assets/img/goal-cardio.jpg')" role="img" aria-label="Cardio"></div>
                        <div class="absolute inset-0 bg-gradient-to-t from-[#1A1A1A] to-transparent"></div>
                    </div>
                    <div class="relative z-10 flex-grow p-6 flex flex-col justify-between">
                        <div class="w-10 h-10 rounded-full bg-surface-container-highest border border-border-industrial flex items-center justify-center
                                    group-hover:bg-primary-fixed group-hover:text-black group-hover:scale-110 transition-all">
                            <span class="material-symbols-outlined">directions_run</span>
                        </div>
                        <div>
                            <h3 class="font-label-md text-label-md text-primary uppercase mb-1">Cardio</h3>
                            <div class="w-0 h-px bg-primary-fixed group-hover:w-full transition-all duration-300"></div>
                        </div>
                    </div>
                </a>

                <!-- Goal: Recuperación -->
                <a class="group relative bg-surface-charcoal border border-border-industrial rounded-DEFAULT overflow-hidden
                          hover:border-primary-fixed transition-all duration-300 flex flex-col h-48 md:h-64 product-card"
                   href="${contextPath}/app?accion=listarSuplementos" id="goal-recuperacion">
                    <div class="absolute inset-0 z-0">
                        <div class="absolute inset-0 bg-cover bg-center opacity-20 group-hover:opacity-40 transition-opacity duration-500
                                    mix-blend-luminosity grayscale group-hover:grayscale-0 product-image"
                             style="background-image: url('${contextPath}/assets/img/goal-recuperacion.jpg')" role="img" aria-label="Recuperación"></div>
                        <div class="absolute inset-0 bg-gradient-to-t from-[#1A1A1A] to-transparent"></div>
                    </div>
                    <div class="relative z-10 flex-grow p-6 flex flex-col justify-between">
                        <div class="w-10 h-10 rounded-full bg-surface-container-highest border border-border-industrial flex items-center justify-center
                                    group-hover:bg-primary-fixed group-hover:text-black group-hover:scale-110 transition-all">
                            <span class="material-symbols-outlined">health_and_safety</span>
                        </div>
                        <div>
                            <h3 class="font-label-md text-label-md text-primary uppercase mb-1">Recuperación</h3>
                            <div class="w-0 h-px bg-primary-fixed group-hover:w-full transition-all duration-300"></div>
                        </div>
                    </div>
                </a>

                <!-- Goal: Pérdida de Grasa -->
                <a class="group relative bg-surface-charcoal border border-border-industrial rounded-DEFAULT overflow-hidden
                          hover:border-primary-fixed transition-all duration-300 flex flex-col h-48 md:h-64 product-card"
                   href="${contextPath}/app?accion=listarSuplementos" id="goal-perdida-grasa">
                    <div class="absolute inset-0 z-0">
                        <div class="absolute inset-0 bg-cover bg-center opacity-20 group-hover:opacity-40 transition-opacity duration-500
                                    mix-blend-luminosity grayscale group-hover:grayscale-0 product-image"
                             style="background-image: url('${contextPath}/assets/img/goal-perdidagrasa.jpg')" role="img" aria-label="Pérdida de Grasa"></div>
                        <div class="absolute inset-0 bg-gradient-to-t from-[#1A1A1A] to-transparent"></div>
                    </div>
                    <div class="relative z-10 flex-grow p-6 flex flex-col justify-between">
                        <div class="w-10 h-10 rounded-full bg-surface-container-highest border border-border-industrial flex items-center justify-center
                                    group-hover:bg-primary-fixed group-hover:text-black group-hover:scale-110 transition-all">
                            <span class="material-symbols-outlined">local_fire_department</span>
                        </div>
                        <div>
                            <h3 class="font-label-md text-label-md text-primary uppercase mb-1">Pérdida de Grasa</h3>
                            <div class="w-0 h-px bg-primary-fixed group-hover:w-full transition-all duration-300"></div>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </section>

    <!-- ================================================================
         SECCIÓN 3: BENTO BOX CATEGORIES
         Mockup F03: Capturar el grid 2x2 de categorías con imágenes
         ================================================================ -->
    <section class="py-24 px-margin-mobile md:px-margin-desktop bg-surface-charcoal border-b border-border-industrial"
             id="section-categories" aria-labelledby="categories-heading">
        <div class="max-w-container-max mx-auto">
            <div class="mb-12">
                <h2 id="categories-heading" class="font-headline-md text-headline-md text-primary">Nuestras Categorías</h2>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-gutter">

                <!-- Maquinaria Pesada -->
                <a href="${contextPath}/app?accion=listarEquipamiento"
                   class="bg-[#0A0A0A] border border-border-industrial rounded-DEFAULT p-6 h-80 relative overflow-hidden group cursor-pointer product-card"
                   id="cat-maquinaria-pesada">
                    <img class="absolute inset-0 w-full h-full object-cover opacity-30 group-hover:opacity-50 transition-opacity duration-300 mix-blend-luminosity product-image"
                         src="${contextPath}/assets/img/bento-pesada.jpg" alt="Maquinaria Pesada de Gimnasio"/>
                    <div class="absolute inset-0 bg-gradient-to-t from-[#0A0A0A] to-transparent"></div>
                    <div class="relative z-10 h-full flex flex-col justify-end">
                        <h3 class="font-headline-md text-headline-md text-primary mb-2">Maquinaria Pesada</h3>
                        <span class="text-primary-fixed font-label-md flex items-center gap-1 group-hover:gap-2 transition-all">
                            <span class="material-symbols-outlined text-[18px]">arrow_forward</span> Explorar
                        </span>
                    </div>
                </a>

                <!-- Maquinaria Ligera -->
                <a href="${contextPath}/app?accion=listarEquipamiento"
                   class="bg-[#0A0A0A] border border-border-industrial rounded-DEFAULT p-6 h-80 relative overflow-hidden group cursor-pointer product-card"
                   id="cat-maquinaria-ligera">
                    <img class="absolute inset-0 w-full h-full object-cover opacity-30 group-hover:opacity-50 transition-opacity duration-300 mix-blend-luminosity product-image"
                         src="${contextPath}/assets/img/bento-ligera.jpg" alt="Maquinaria Ligera de Gimnasio"/>
                    <div class="absolute inset-0 bg-gradient-to-t from-[#0A0A0A] to-transparent"></div>
                    <div class="relative z-10 h-full flex flex-col justify-end">
                        <h3 class="font-headline-md text-headline-md text-primary mb-2">Maquinaria Ligera</h3>
                        <span class="text-primary-fixed font-label-md flex items-center gap-1 group-hover:gap-2 transition-all">
                            <span class="material-symbols-outlined text-[18px]">arrow_forward</span> Explorar
                        </span>
                    </div>
                </a>

                <!-- Suplementación -->
                <a href="${contextPath}/app?accion=listarSuplementos"
                   class="bg-[#0A0A0A] border border-border-industrial rounded-DEFAULT p-6 h-80 relative overflow-hidden group cursor-pointer product-card"
                   id="cat-suplementacion">
                    <img class="absolute inset-0 w-full h-full object-cover opacity-30 group-hover:opacity-50 transition-opacity duration-300 mix-blend-luminosity product-image"
                         src="${contextPath}/assets/img/bento-suplementacion.jpg" alt="Suplementación Deportiva"/>
                    <div class="absolute inset-0 bg-gradient-to-t from-[#0A0A0A] to-transparent"></div>
                    <div class="relative z-10 h-full flex flex-col justify-end">
                        <h3 class="font-headline-md text-headline-md text-primary mb-2">Suplementación</h3>
                        <span class="text-primary-fixed font-label-md flex items-center gap-1 group-hover:gap-2 transition-all">
                            <span class="material-symbols-outlined text-[18px]">arrow_forward</span> Explorar
                        </span>
                    </div>
                </a>

                <!-- Accesorios -->
                <a href="${contextPath}/app?accion=listarEquipamiento"
                   class="bg-[#0A0A0A] border border-border-industrial rounded-DEFAULT p-6 h-80 relative overflow-hidden group cursor-pointer product-card"
                   id="cat-accesorios">
                    <img class="absolute inset-0 w-full h-full object-cover opacity-30 group-hover:opacity-50 transition-opacity duration-300 mix-blend-luminosity product-image"
                         src="${contextPath}/assets/img/bento-accesorios.jpg" alt="Accesorios de Entrenamiento"/>
                    <div class="absolute inset-0 bg-gradient-to-t from-[#0A0A0A] to-transparent"></div>
                    <div class="relative z-10 h-full flex flex-col justify-end">
                        <h3 class="font-headline-md text-headline-md text-primary mb-2">Accesorios</h3>
                        <span class="text-primary-fixed font-label-md flex items-center gap-1 group-hover:gap-2 transition-all">
                            <span class="material-symbols-outlined text-[18px]">arrow_forward</span> Explorar
                        </span>
                    </div>
                </a>
            </div>
        </div>
    </section>

    <!-- ================================================================
         SECCIÓN 4: PROMO BANNER
         Mockup F20: Capturar banner verde con CTA a Planes
         ================================================================ -->
    <section class="py-16 px-margin-mobile md:px-margin-desktop bg-primary-fixed text-on-primary-fixed border-b border-border-industrial"
             id="section-promo" aria-labelledby="promo-heading">
        <div class="max-w-container-max mx-auto flex flex-col md:flex-row items-center justify-between gap-8">
            <div>
                <h2 id="promo-heading" class="font-headline-lg text-headline-lg-mobile md:text-headline-lg mb-2">
                    LLEVA TU ENTRENAMIENTO AL SIGUIENTE NIVEL
                </h2>
                <p class="font-body-lg text-body-lg opacity-80">
                    Planes de entrenamiento personalizados diseñados por expertos.
                </p>
            </div>
            <a href="${contextPath}/app?accion=configurarPlan"
               class="bg-black text-primary-fixed font-label-md text-label-md px-8 py-4 rounded-DEFAULT
                      hover:bg-surface-charcoal hover:text-primary-fixed transition-all duration-150
                      uppercase whitespace-nowrap font-semibold"
               id="promo-cta">
                Crear mi Plan
            </a>
        </div>
    </section>

<!-- Hero video background script -->
<script>
(function initHeroVideoBackground() {
    const clips = [
        '${contextPath}/assets/video/hero-1.mp4',
        '${contextPath}/assets/video/hero-2.mp4',
        '${contextPath}/assets/video/hero-3.mp4'
    ];
    const stage = document.getElementById('hero-bg-stage');
    if (!stage) return;
    const videos = stage.querySelectorAll('.hero-bg-video');
    if (!videos.length) return;

    let current = 0, next = 1, clipIndex = 0;
    const supportsVideo = !!document.createElement('video').canPlayType;
    if (!supportsVideo) return;

    videos[current].src = clips[clipIndex];
    const p = videos[current].play();
    if (p) p.catch(() => {});

    function playNextClip() {
        clipIndex = (clipIndex + 1) % clips.length;
        const nextEl = videos[next], curEl = videos[current];
        nextEl.src = clips[clipIndex];
        nextEl.currentTime = 0;
        const pp = nextEl.play();
        if (pp) pp.catch(() => {});
        nextEl.classList.add('active');
        curEl.classList.remove('active');
        current = next;
        next = current === 0 ? 1 : 0;
    }

    videos.forEach(video => {
        video.addEventListener('timeupdate', () => {
            if (!video.classList.contains('active')) return;
            if (video.duration && video.currentTime >= video.duration - 1.4) {
                if (video.dataset.transitioning === 'true') return;
                video.dataset.transitioning = 'true';
                playNextClip();
                setTimeout(() => { video.dataset.transitioning = 'false'; }, 2000);
            }
        });
    });
})();
</script>

<%@ include file="includes/footer.jsp" %>
