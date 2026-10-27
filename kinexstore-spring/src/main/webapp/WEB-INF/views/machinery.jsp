<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%--
     VISTA: machinery.jsp — Catálogo de Equipamiento
     GET: /catalogo/equipamiento[?cat=racks&cat=poleas]
     Atributos:
       - productos (List<Product>)
       - categoriasDisponibles (String[])
       - categoriasSeleccionadas (List<String>)
--%>
<c:set var="pageTitle" value="Equipamiento" />
<c:set var="pageDescription" value="Catálogo de maquinaria pesada y ligera de gimnasio. Power Racks, Prensas, Poleas, Máquinas Smith y más." />
<c:set var="vistaActiva" value="equipamiento" />
<%@ include file="includes/header.jsp" %>

    <!-- ================================================================
         CATÁLOGO DE EQUIPAMIENTO
         ================================================================ -->
    <div class="max-w-7xl mx-auto px-4 md:px-8 py-12 flex flex-col md:flex-row gap-8" id="section-equipamiento">

        <!-- ---- SIDEBAR: FILTROS ---- -->
        <aside class="w-full md:w-56 flex-shrink-0" aria-label="Filtros de equipamiento">
            <form method="get" action="${contextPath}/catalogo/equipamiento" id="filter-form-equipamiento">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="font-headline-md text-headline-md text-primary">Filtros</h3>
                    <a href="${contextPath}/catalogo/equipamiento"
                       class="text-xs font-label-sm text-on-surface-variant hover:text-primary-fixed transition-colors underline"
                       id="limpiar-filtros-equipamiento">Limpiar</a>
                </div>
                <div class="space-y-4">
                    <c:forEach var="cat" items="${categoriasDisponibles}">
                        <label class="flex items-center gap-2 cursor-pointer hover:text-primary-fixed transition-colors">
                            <input class="form-checkbox bg-surface-charcoal border-border-industrial text-primary-fixed focus:ring-primary-fixed"
                                   type="checkbox" name="cat" value="${cat}" id="filter-${cat}"
                                   onchange="this.form.submit()"
                                   <c:if test="${categoriasSeleccionadas.contains(cat)}">checked</c:if>>
                            <span class="font-body-md text-on-surface">
                                <c:choose>
                                    <c:when test="${cat == 'racks'}">Racks / Jaulas</c:when>
                                    <c:when test="${cat == 'poleas'}">Poleas</c:when>
                                    <c:when test="${cat == 'prensas'}">Prensas</c:when>
                                    <c:when test="${cat == 'bancos'}">Bancos</c:when>
                                    <c:when test="${cat == 'smith'}">Máquinas Smith</c:when>
                                    <c:otherwise>${cat}</c:otherwise>
                                </c:choose>
                            </span>
                        </label>
                    </c:forEach>
                </div>
            </form>
        </aside>

        <!-- ---- PRODUCT GRID ---- -->
        <div class="flex-grow min-w-0">

            <!-- Confirmación de producto agregado -->
            <c:if test="${not empty param.msg and param.msg == 'agregado'}">
                <div class="mb-4 p-3 bg-green-900/40 border border-green-700 rounded flex items-center gap-2 text-green-300 text-sm"
                     role="alert" id="cart-toast">
                    <span class="material-symbols-outlined text-[18px]">check_circle</span>
                    ¡Producto agregado al carrito! —
                    <a href="${contextPath}/carrito" class="underline font-semibold hover:text-white">Ver carrito →</a>
                </div>
            </c:if>

            <div class="mb-6 flex justify-between items-center">
                <p class="font-label-sm text-on-surface-variant">
                    <c:choose>
                        <c:when test="${empty productos}">Sin resultados</c:when>
                        <c:otherwise>${productos.size()} producto<c:if test="${productos.size() != 1}">s</c:if> encontrado<c:if test="${productos.size() != 1}">s</c:if></c:otherwise>
                    </c:choose>
                </p>
            </div>

            <c:choose>
                <c:when test="${not empty productos}">
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6" id="machinery-product-grid">
                        <c:forEach var="producto" items="${productos}" varStatus="loop">
                            <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT overflow-hidden flex flex-col product-card
                                        hover:border-primary-fixed/50 transition-all duration-200"
                                 data-category="${producto.categoria}"
                                 id="prod-equip-${producto.id}">

                                <!-- Imagen — clic va al detalle -->
                                <a href="${contextPath}/producto/${producto.id}" class="block">
                                    <div class="aspect-video overflow-hidden bg-[#0A0A0A]">
                                        <img class="w-full h-full object-cover mix-blend-luminosity hover:mix-blend-normal hover:scale-105 transition-all duration-300 product-image"
                                             src="${contextPath}/${producto.imagenPath}"
                                             alt="${producto.nombre}"
                                             loading="${loop.index < 3 ? 'eager' : 'lazy'}"/>
                                    </div>
                                </a>

                                <div class="p-4 flex flex-col flex-grow">
                                    <h4 class="font-label-md text-primary mb-1">
                                        <a href="${contextPath}/producto/${producto.id}" class="hover:text-primary-fixed transition-colors">
                                            ${producto.nombre}
                                        </a>
                                    </h4>
                                    <p class="font-body-md text-on-surface-variant text-sm mb-2 line-clamp-2">${producto.descripcion}</p>
                                    <div class="flex items-center gap-2 text-xs font-mono text-on-surface-variant mb-3">
                                        <span class="text-primary-fixed/90 font-semibold">⚖️ ${producto.pesoDual}</span>
                                        <c:if test="${not empty producto.dimensiones and producto.dimensiones != 'N/A'}">
                                            <span class="text-on-surface-variant/70">· 📐 ${producto.dimensiones}</span>
                                        </c:if>
                                    </div>

                                    <!-- Footer de la tarjeta: precio + botón agregar -->
                                    <div class="flex items-center justify-between mt-auto pt-3 border-t border-border-industrial gap-2">
                                        <span class="font-label-md text-primary font-bold truncate">${producto.precioFormateado}</span>

                                        <div class="flex items-center gap-2 flex-shrink-0">
                                            <!-- Ver detalle -->
                                            <a href="${contextPath}/producto/${producto.id}"
                                               class="w-8 h-8 rounded border border-border-industrial flex items-center justify-center
                                                      hover:border-primary-fixed hover:text-primary-fixed transition-all"
                                               title="Ver detalles"
                                               id="detail-equip-${producto.id}">
                                                <span class="material-symbols-outlined text-[16px]">open_in_new</span>
                                            </a>
                                            <!-- Agregar al carrito (sin cambiar de página) -->
                                            <form method="post" action="${contextPath}/carrito/agregar" class="inline">
                                                <input type="hidden" name="productoId" value="${producto.id}">
                                                <input type="hidden" name="cantidad" value="1">
                                                <input type="hidden" name="origen" value="${contextPath}/catalogo/equipamiento">
                                                <button type="submit"
                                                        class="w-8 h-8 rounded bg-primary-fixed/10 border border-primary-fixed/30 flex items-center justify-center
                                                               hover:bg-primary-fixed hover:text-black transition-all btn-add"
                                                        id="add-equip-${producto.id}"
                                                        title="Agregar al carrito"
                                                        aria-label="Agregar ${producto.nombre} al carrito">
                                                    <span class="material-symbols-outlined text-[18px]">add_shopping_cart</span>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="py-16 text-center text-on-surface-variant" id="machinery-no-results">
                        <span class="material-symbols-outlined text-4xl block mb-2 opacity-50">search_off</span>
                        <p class="font-body-md">No se encontraron equipos en esta categoría.</p>
                        <a href="${contextPath}/catalogo/equipamiento"
                           class="mt-4 inline-block text-primary-fixed font-label-md hover:underline">
                            Ver todo el equipamiento →
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

<script>
    // Auto-hide del toast de confirmación tras 4 segundos
    const toast = document.getElementById('cart-toast');
    if (toast) {
        setTimeout(() => toast.style.display = 'none', 4000);
    }
</script>

<%@ include file="includes/footer.jsp" %>
