<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%--
     VISTA: producto_detalle.jsp
     GET: /producto/{id}
     Atributos:
       - producto (Product): producto a mostrar
       - crossSelling (List<Product>): hasta 4 productos recomendados
--%>
<c:set var="pageTitle" value="${producto.nombre}" />
<c:set var="pageDescription" value="${producto.descripcion}" />
<%@ include file="includes/header.jsp" %>

    <!-- ================================================================
         DETALLE DE PRODUCTO
         ================================================================ -->
    <div class="max-w-5xl mx-auto px-4 md:px-8 py-12" id="section-producto-detalle">

        <!-- Migas de pan -->
        <nav class="flex items-center gap-2 text-xs text-on-surface-variant mb-8 font-label-sm" aria-label="Migas de pan">
            <a href="${contextPath}/" class="hover:text-primary-fixed transition-colors">Inicio</a>
            <span class="material-symbols-outlined text-[14px]">chevron_right</span>
            <c:choose>
                <c:when test="${producto.tipo.name() == 'EQUIPAMIENTO'}">
                    <a href="${contextPath}/catalogo/equipamiento" class="hover:text-primary-fixed transition-colors">Equipamiento</a>
                </c:when>
                <c:otherwise>
                    <a href="${contextPath}/catalogo/suplementos" class="hover:text-primary-fixed transition-colors">Suplementación</a>
                </c:otherwise>
            </c:choose>
            <span class="material-symbols-outlined text-[14px]">chevron_right</span>
            <span class="text-primary truncate max-w-[200px]">${producto.nombre}</span>
        </nav>

        <!-- Grid principal: imagen + info -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-10 mb-16">

            <!-- Imagen -->
            <div class="relative group">
                <div class="aspect-square rounded-lg overflow-hidden border border-border-industrial bg-[#0A0A0A]">
                    <img src="${contextPath}/${producto.imagenPath}"
                         alt="${producto.nombre}"
                         class="w-full h-full object-cover mix-blend-luminosity group-hover:mix-blend-normal transition-all duration-500 group-hover:scale-105"
                         id="prod-detail-img-${producto.id}">
                </div>
                <!-- Badge estado caducidad (solo suplementos) -->
                <c:if test="${producto.tipo.name() == 'SUPLEMENTO'}">
                    <span class="absolute top-4 left-4 text-xs font-label-sm px-3 py-1 rounded-full
                                 ${producto.estadoCaducidadBadge == 'OPTIMO' ? 'bg-green-900/80 text-green-300 border border-green-700' :
                                   producto.estadoCaducidadBadge == 'PROXIMO_A_VENCER' ? 'bg-yellow-900/80 text-yellow-300 border border-yellow-700' :
                                   'bg-red-900/80 text-red-300 border border-red-700'}">
                        <c:choose>
                            <c:when test="${producto.estadoCaducidadBadge == 'OPTIMO'}">✓ Óptimo</c:when>
                            <c:when test="${producto.estadoCaducidadBadge == 'PROXIMO_A_VENCER'}">⚠ Próximo a vencer</c:when>
                            <c:otherwise>✕ Vencido</c:otherwise>
                        </c:choose>
                    </span>
                </c:if>
            </div>

            <!-- Información del producto -->
            <div class="flex flex-col">

                <!-- Categoría badge -->
                <span class="text-xs font-label-sm text-primary-fixed border border-primary-fixed/30 px-3 py-1 rounded-full w-fit mb-4 uppercase tracking-wider">
                    ${producto.categoria}
                </span>

                <h1 class="font-headline-lg text-primary mb-3 leading-tight">${producto.nombre}</h1>
                <p class="font-body-md text-on-surface-variant mb-6 leading-relaxed">${producto.descripcion}</p>

                <!-- Datos técnicos -->
                <div class="grid grid-cols-2 gap-3 mb-6">
                    <div class="bg-[#0A0A0A] border border-border-industrial rounded p-3">
                        <p class="text-xs text-on-surface-variant font-label-sm mb-1">⚖️ Peso</p>
                        <p class="font-label-md text-primary-fixed">${producto.pesoDual}</p>
                    </div>
                    <c:if test="${not empty producto.dimensiones and producto.dimensiones != 'N/A'}">
                        <div class="bg-[#0A0A0A] border border-border-industrial rounded p-3">
                            <p class="text-xs text-on-surface-variant font-label-sm mb-1">📐 Dimensiones</p>
                            <p class="font-label-md text-primary">${producto.dimensiones}</p>
                        </div>
                    </c:if>
                    <div class="bg-[#0A0A0A] border border-border-industrial rounded p-3">
                        <p class="text-xs text-on-surface-variant font-label-sm mb-1">📦 Stock</p>
                        <p class="font-label-md text-primary">${producto.stock} unid.</p>
                    </div>
                    <c:if test="${not empty producto.registroInvima and producto.registroInvima != 'RSA-PENDIENTE'}">
                        <div class="bg-[#0A0A0A] border border-border-industrial rounded p-3">
                            <p class="text-xs text-on-surface-variant font-label-sm mb-1">🏥 INVIMA</p>
                            <p class="font-label-md text-primary text-xs">${producto.registroInvima}</p>
                        </div>
                    </c:if>
                </div>

                <!-- Precio y descuento mayorista -->
                <div class="mb-6">
                    <p class="text-3xl font-bold text-primary-fixed mb-1">${producto.precioFormateado}</p>
                    <c:if test="${producto.descuentoMayoristaPct > 0}">
                        <p class="text-xs text-on-surface-variant font-label-sm">
                            🏷 Descuento mayorista disponible (3+ unidades)
                        </p>
                    </c:if>
                </div>

                <!-- Confirmación de producto agregado -->
                <c:if test="${not empty param.msg and param.msg == 'agregado' and param.pid == producto.id}">
                    <div class="mb-4 p-3 bg-green-900/40 border border-green-700 rounded flex items-center gap-2 text-green-300 text-sm animate-bounce-once"
                         role="alert">
                        <span class="material-symbols-outlined text-[18px]">check_circle</span>
                        ¡Producto agregado al carrito!
                    </div>
                </c:if>

                <!-- Formulario agregar al carrito (vuelve a esta misma página) -->
                <form method="post" action="${contextPath}/carrito/agregar" class="flex items-center gap-3 mb-4">
                    <input type="hidden" name="productoId" value="${producto.id}">
                    <input type="hidden" name="origen" value="${contextPath}/producto/${producto.id}">
                    <div class="flex items-center border border-border-industrial rounded overflow-hidden">
                        <label for="cantidad-detalle" class="sr-only">Cantidad</label>
                        <input type="number" id="cantidad-detalle" name="cantidad"
                               value="1" min="1" max="99"
                               class="w-16 bg-[#0A0A0A] text-center text-primary font-bold py-3 px-2 focus:ring-1 focus:ring-primary-fixed focus:outline-none border-r border-border-industrial">
                    </div>
                    <button type="submit"
                            class="flex-1 bg-primary-fixed text-black font-label-md px-6 py-3 rounded hover:bg-white
                                   transition-all duration-200 uppercase font-bold tracking-wider flex items-center justify-center gap-2"
                            id="btn-agregar-detalle-${producto.id}">
                        <span class="material-symbols-outlined text-[20px]">add_shopping_cart</span>
                        Agregar al Carrito
                    </button>
                </form>

                <!-- Botón volver -->
                <c:choose>
                    <c:when test="${producto.tipo.name() == 'EQUIPAMIENTO'}">
                        <a href="${contextPath}/catalogo/equipamiento"
                           class="text-center border border-border-industrial text-on-surface-variant font-label-sm px-4 py-3 rounded
                                  hover:border-primary-fixed hover:text-primary-fixed transition-colors text-sm">
                            ← Volver al catálogo de equipamiento
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${contextPath}/catalogo/suplementos"
                           class="text-center border border-border-industrial text-on-surface-variant font-label-sm px-4 py-3 rounded
                                  hover:border-primary-fixed hover:text-primary-fixed transition-colors text-sm">
                            ← Volver a suplementación
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- ============================================================
             CROSS-SELLING: "Te podría interesar..."
             ============================================================ -->
        <c:if test="${not empty crossSelling}">
            <section class="border-t border-border-industrial pt-12" aria-label="Productos relacionados">
                <div class="flex items-center gap-3 mb-8">
                    <span class="material-symbols-outlined text-primary-fixed text-2xl">recommend</span>
                    <h2 class="font-headline-md text-primary">Te podría interesar...</h2>
                </div>

                <div class="grid grid-cols-2 md:grid-cols-4 gap-4" id="cross-selling-grid">
                    <c:forEach var="rel" items="${crossSelling}">
                        <a href="${contextPath}/producto/${rel.id}"
                           class="group bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-3 flex flex-col
                                  hover:border-primary-fixed transition-all duration-200 hover:-translate-y-1"
                           id="cross-${rel.id}">
                            <div class="aspect-square overflow-hidden rounded mb-3 bg-[#0A0A0A]">
                                <img src="${contextPath}/${rel.imagenPath}"
                                     alt="${rel.nombre}"
                                     class="w-full h-full object-cover mix-blend-luminosity group-hover:mix-blend-normal
                                            group-hover:scale-105 transition-all duration-300"
                                     loading="lazy">
                            </div>
                            <h4 class="font-label-sm text-primary text-sm mb-1 leading-tight line-clamp-2 group-hover:text-primary-fixed transition-colors">${rel.nombre}</h4>
                            <p class="font-label-md text-primary-fixed font-bold mt-auto">${rel.precioFormateado}</p>
                        </a>
                    </c:forEach>
                </div>
            </section>
        </c:if>

    </div>

<%@ include file="includes/footer.jsp" %>
