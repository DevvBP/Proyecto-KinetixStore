<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
     VISTA: plan_resultado.jsp
     POST: /planes/generar → /planes/generar-post-auth
     Atributos:
       - planGenerado (TrainingPlan)
       - suplementosRecomendados (String[]): nombres de suplementos sugeridos
       - suplementosReales (List<Product>): productos reales del catálogo
--%>
<c:set var="pageTitle" value="Plan Generado — ${planGenerado.objetivo.etiqueta}" />
<%@ include file="includes/header.jsp" %>

    <div class="max-w-3xl mx-auto px-4 md:px-8 py-16" id="section-plan-resultado">

        <!-- Header celebratorio -->
        <div class="text-center mb-10">
            <div class="w-20 h-20 rounded-full bg-primary-fixed/10 border-2 border-primary-fixed flex items-center justify-center mx-auto mb-4">
                <span class="material-symbols-outlined text-4xl text-primary-fixed animate-pulse">auto_awesome</span>
            </div>
            <h1 class="font-headline-lg text-primary mb-2">¡Tu Plan está listo!</h1>
            <p class="font-body-md text-on-surface-variant">
                Hola <strong class="text-primary-fixed">${planGenerado.nombreUsuario}</strong> —
                un especialista KinexStore revisará tu plan en las próximas 24 horas.
            </p>
        </div>

        <!-- Tarjeta del Plan -->
        <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-6 md:p-8 mb-8 space-y-6">

            <!-- Encabezado del plan -->
            <div class="flex flex-wrap items-center justify-between gap-3 pb-4 border-b border-border-industrial">
                <span class="font-label-sm text-on-surface-variant">Plan #${planGenerado.id}</span>
                <span class="bg-primary-fixed text-black font-label-sm px-3 py-1 rounded-full">
                    ${planGenerado.nivel.etiqueta}
                </span>
            </div>

            <!-- Grid de datos -->
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
                <div class="bg-[#0A0A0A] rounded p-3 text-center">
                    <p class="text-xs text-on-surface-variant font-label-sm mb-1">🎯 Objetivo</p>
                    <p class="font-label-md text-primary text-sm">${planGenerado.objetivo.etiqueta}</p>
                </div>
                <div class="bg-[#0A0A0A] rounded p-3 text-center">
                    <p class="text-xs text-on-surface-variant font-label-sm mb-1">📅 Frecuencia</p>
                    <p class="font-label-md text-primary text-sm">${planGenerado.diasPorSemana} días/sem</p>
                </div>
                <div class="bg-[#0A0A0A] rounded p-3 text-center">
                    <p class="text-xs text-on-surface-variant font-label-sm mb-1">🏋️ Atleta</p>
                    <p class="font-label-md text-primary text-sm truncate">${planGenerado.nombreUsuario}</p>
                </div>
                <c:if test="${not empty planGenerado.emailUsuario}">
                    <div class="bg-[#0A0A0A] rounded p-3 text-center">
                        <p class="text-xs text-on-surface-variant font-label-sm mb-1">📧 Contacto</p>
                        <p class="font-label-md text-primary text-xs truncate">${planGenerado.emailUsuario}</p>
                    </div>
                </c:if>
            </div>

            <!-- Suplementos sugeridos (nombres) -->
            <c:if test="${not empty suplementosRecomendados}">
                <div class="pt-4 border-t border-border-industrial">
                    <p class="font-label-md text-on-surface-variant mb-3 flex items-center gap-2">
                        <span class="material-symbols-outlined text-[18px] text-primary-fixed">recommend</span>
                        Stack de Suplementación Sugerido:
                    </p>
                    <div class="flex flex-wrap gap-2">
                        <c:forEach var="supl" items="${suplementosRecomendados}">
                            <span class="bg-[#0A0A0A] border border-border-industrial px-3 py-1
                                         font-label-sm text-primary rounded-full text-sm">${supl}</span>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- Descripción generada -->
            <div class="pt-4 border-t border-border-industrial">
                <p class="font-label-md text-on-surface-variant mb-2 flex items-center gap-2">
                    <span class="material-symbols-outlined text-[18px]">assignment</span>
                    Descripción del Plan
                </p>
                <pre class="font-body-md text-on-surface-variant text-sm whitespace-pre-wrap leading-relaxed
                            bg-[#0A0A0A] rounded p-4 border border-border-industrial/50">${planGenerado.descripcionGenerada}</pre>
            </div>
        </div>

        <!-- ============================================================
             SINERGIA E-COMMERCE: Suplementos Reales del Catálogo (P3)
             ============================================================ -->
        <c:if test="${not empty suplementosReales}">
            <section class="mb-10" aria-label="Productos recomendados para tu plan">
                <div class="flex items-center gap-3 mb-6">
                    <span class="material-symbols-outlined text-primary-fixed text-2xl">shopping_bag</span>
                    <div>
                        <h2 class="font-headline-md text-primary">Productos para tu Plan</h2>
                        <p class="text-sm text-on-surface-variant">Basados en tu objetivo: ${planGenerado.objetivo.etiqueta}</p>
                    </div>
                </div>

                <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                    <c:forEach var="prod" items="${suplementosReales}">
                        <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT overflow-hidden flex flex-col
                                    hover:border-primary-fixed/50 transition-all duration-200 group"
                             id="plan-prod-${prod.id}">

                            <a href="${contextPath}/producto/${prod.id}" class="block">
                                <div class="aspect-video overflow-hidden bg-[#0A0A0A]">
                                    <img src="${contextPath}/${prod.imagenPath}"
                                         alt="${prod.nombre}"
                                         class="w-full h-full object-cover mix-blend-luminosity group-hover:mix-blend-normal
                                                group-hover:scale-105 transition-all duration-300"
                                         loading="lazy">
                                </div>
                            </a>

                            <div class="p-3 flex flex-col flex-grow">
                                <h4 class="font-label-sm text-primary text-sm mb-1 leading-tight line-clamp-2">
                                    <a href="${contextPath}/producto/${prod.id}" class="hover:text-primary-fixed transition-colors">
                                        ${prod.nombre}
                                    </a>
                                </h4>
                                <div class="flex items-center justify-between mt-auto pt-2 gap-2">
                                    <span class="font-label-md text-primary-fixed font-bold text-sm truncate">${prod.precioFormateado}</span>
                                    <!-- Agregar al carrito desde el plan -->
                                    <form method="post" action="${contextPath}/carrito/agregar" class="inline">
                                        <input type="hidden" name="productoId" value="${prod.id}">
                                        <input type="hidden" name="cantidad" value="1">
                                        <input type="hidden" name="origen" value="${contextPath}/catalogo/suplementos">
                                        <button type="submit"
                                                class="w-8 h-8 rounded bg-primary-fixed/10 border border-primary-fixed/30 flex items-center justify-center
                                                       hover:bg-primary-fixed hover:text-black transition-all flex-shrink-0"
                                                id="plan-add-${prod.id}"
                                                title="Agregar al carrito"
                                                aria-label="Agregar ${prod.nombre} al carrito">
                                            <span class="material-symbols-outlined text-[18px]">add_shopping_cart</span>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <!-- Acciones -->
        <div class="flex flex-col sm:flex-row gap-4">
            <a href="${contextPath}/catalogo/suplementos"
               class="flex-1 text-center bg-primary-fixed text-black font-label-md px-6 py-4 rounded-DEFAULT
                      hover:bg-white transition-all uppercase font-bold"
               id="btn-ver-suplementos">
                Ver Toda la Suplementación
            </a>
            <a href="${contextPath}/"
               class="flex-1 text-center border border-border-industrial text-on-surface font-label-md px-6 py-4
                      rounded-DEFAULT hover:border-primary-fixed hover:text-primary-fixed transition-colors uppercase"
               id="btn-volver-home">
                Volver al Inicio
            </a>
        </div>
    </div>

<%@ include file="includes/footer.jsp" %>
