<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%--
     VISTA: accessories.jsp — Catálogo Oficial de Accesorios de Alto Rendimiento
     GET: /catalogo/accesorios[?cat=proteccion&cat=agarre]
     Atributos:
       - productos (List<Product>)
       - categoriasDisponibles (String[])
       - categoriasSeleccionadas (List<String>)
--%>
<c:set var="pageTitle" value="Accesorios de Entrenamiento" />
<c:set var="pageDescription" value="Catálogo oficial de accesorios deportivos KinexStore. Cinturones de potencia, lifting straps, rodilleras de neopreno, bandas elásticas y equipamiento funcional." />
<c:set var="vistaActiva" value="accesorios" />
<%@ include file="includes/header.jsp" %>

    <!-- ================================================================
         CATÁLOGO DE ACCESORIOS DE ALTO RENDIMIENTO
         ================================================================ -->
    <div class="max-w-7xl mx-auto px-4 md:px-8 py-12 flex flex-col md:flex-row gap-8" id="section-accesorios">

        <!-- ---- SIDEBAR: FILTROS ---- -->
        <aside class="w-full md:w-64 flex-shrink-0" aria-label="Filtros de accesorios">
            <form method="get" action="${contextPath}/catalogo/accesorios" id="filter-form-accesorios">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="font-headline-md text-headline-md text-primary flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary-fixed text-lg">filter_list</span>
                        Filtros
                    </h3>
                    <a href="${contextPath}/catalogo/accesorios"
                       class="text-xs font-label-sm text-on-surface-variant hover:text-primary-fixed transition-colors underline"
                       id="limpiar-filtros-accesorios">Limpiar</a>
                </div>
                <div class="space-y-3 bg-surface-charcoal border border-border-industrial p-4 rounded-DEFAULT">
                    <c:forEach var="cat" items="${categoriasDisponibles}">
                        <label class="flex items-center gap-2 cursor-pointer hover:text-primary-fixed transition-colors py-1">
                            <input class="form-checkbox bg-[#0A0A0A] border-border-industrial text-primary-fixed focus:ring-primary-fixed rounded"
                                   type="checkbox" name="cat" value="${cat}" id="filter-${cat}"
                                   onchange="this.form.submit()"
                                   <c:if test="${categoriasSeleccionadas.contains(cat)}">checked</c:if>>
                            <span class="font-body-md text-sm text-on-surface">
                                <c:choose>
                                    <c:when test="${cat == 'proteccion'}">🛡️ Protección y Soporte</c:when>
                                    <c:when test="${cat == 'agarre'}">✋ Agarre y Grip</c:when>
                                    <c:when test="${cat == 'hidratacion'}">🥤 Hidratación y Shakers</c:when>
                                    <c:when test="${cat == 'funcional'}">⚡ Funcional y Poleas</c:when>
                                    <c:when test="${cat == 'recuperacion'}">🧘 Recuperación Miofascial</c:when>
                                    <c:when test="${cat == 'pesas'}">🏋️ Accesorios de Barra</c:when>
                                    <c:when test="${cat == 'fuerza'}">⛓️ Dominadas y Sobrecarga</c:when>
                                    <c:when test="${cat == 'medicion'}">📊 Medición Corporal</c:when>
                                    <c:when test="${cat == 'transporte'}">🎒 Bolsos y Maletines</c:when>
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
                    ¡Accesorio agregado al carrito de compras! —
                    <a href="${contextPath}/carrito" class="underline font-semibold hover:text-white">Ver carrito →</a>
                </div>
            </c:if>

            <div class="mb-6 flex justify-between items-center">
                <p class="font-label-sm text-on-surface-variant">
                    <c:choose>
                        <c:when test="${empty productos}">Sin accesorios en esta categoría</c:when>
                        <c:otherwise>${productos.size()} accesorio<c:if test="${productos.size() != 1}">s</c:if> disponible<c:if test="${productos.size() != 1}">s</c:if></c:otherwise>
                    </c:choose>
                </p>
                <span class="text-xs font-mono text-primary-fixed bg-primary-fixed/10 px-3 py-1 rounded-full border border-primary-fixed/20">
                    Línea Oficial KinexStore Pro
                </span>
            </div>

            <c:choose>
                <c:when test="${not empty productos}">
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6" id="accessories-product-grid">
                        <c:forEach var="producto" items="${productos}" varStatus="loop">
                            <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT overflow-hidden flex flex-col product-card
                                        hover:border-primary-fixed/50 transition-all duration-200 group"
                                 data-category="${producto.categoria}"
                                 id="prod-acc-${producto.id}">

                                <!-- Imagen — clic va al detalle -->
                                <a href="${contextPath}/producto/${producto.id}" class="block relative">
                                    <div class="aspect-video overflow-hidden bg-[#0A0A0A]">
                                        <img class="w-full h-full object-cover mix-blend-luminosity group-hover:mix-blend-normal group-hover:scale-105 transition-all duration-300 product-image"
                                             src="${contextPath}/${producto.imagenPath}"
                                             alt="${producto.nombre}"
                                             loading="${loop.index < 3 ? 'eager' : 'lazy'}"/>
                                    </div>
                                    <span class="absolute top-2 right-2 bg-black/80 backdrop-blur text-primary-fixed text-[11px] font-mono px-2 py-0.5 rounded border border-primary-fixed/30">
                                        Stock: ${producto.stock}
                                    </span>
                                </a>

                                <div class="p-4 flex flex-col flex-grow">
                                    <h4 class="font-label-md text-primary mb-1">
                                        <a href="${contextPath}/producto/${producto.id}" class="hover:text-primary-fixed transition-colors">
                                            ${producto.nombre}
                                        </a>
                                    </h4>
                                    <p class="font-body-md text-on-surface-variant text-sm mb-2 line-clamp-2">${producto.descripcion}</p>
                                    
                                    <div class="flex flex-wrap items-center gap-2 text-xs font-mono text-on-surface-variant mb-3">
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
                                               title="Ver detalles del accesorio"
                                               id="detail-acc-${producto.id}">
                                                <span class="material-symbols-outlined text-[16px]">open_in_new</span>
                                            </a>
                                            <!-- Agregar al carrito -->
                                            <form method="post" action="${contextPath}/carrito/agregar" class="inline">
                                                <input type="hidden" name="productoId" value="${producto.id}">
                                                <input type="hidden" name="cantidad" value="1">
                                                <input type="hidden" name="origen" value="${contextPath}/catalogo/accesorios">
                                                <button type="submit"
                                                        class="w-8 h-8 rounded bg-primary-fixed/10 border border-primary-fixed/30 flex items-center justify-center
                                                               hover:bg-primary-fixed hover:text-black transition-all btn-add"
                                                        id="add-acc-${producto.id}"
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
                    <div class="text-center py-16 bg-surface-charcoal border border-border-industrial rounded-DEFAULT" id="no-accessories">
                        <span class="material-symbols-outlined text-5xl text-on-surface-variant mb-4">sports_handball</span>
                        <h4 class="font-headline-md text-primary mb-2">No se encontraron accesorios</h4>
                        <p class="font-body-md text-on-surface-variant mb-6">Prueba desmarcando algunos filtros para ver más opciones.</p>
                        <a href="${contextPath}/catalogo/accesorios"
                           class="inline-block bg-primary-fixed text-black font-label-md px-6 py-2 rounded-DEFAULT font-bold hover:bg-white transition-all uppercase">
                            Ver Todos los Accesorios
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </div>

<%@ include file="includes/footer.jsp" %>

