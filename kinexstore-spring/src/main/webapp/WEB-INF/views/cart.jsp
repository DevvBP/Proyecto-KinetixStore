<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%--
     VISTA: cart.jsp
     GET: /carrito
     Atributos:
       - itemsCarrito (List<CartItem>)
       - subtotal (double)
       - pesoTotal (double)
       - envioSugerido (String)
--%>
<c:set var="pageTitle" value="Tu Carrito" />
<c:set var="pageDescription" value="Revisa y gestiona los productos en tu carrito de compras KinexStore." />
<%@ include file="includes/header.jsp" %>

    <!-- ================================================================
         VISTA DEL CARRITO — Diseño responsive corregido
         ================================================================ -->
    <div class="max-w-5xl mx-auto px-4 md:px-8 py-12" id="section-carrito">

        <h1 class="font-headline-lg text-primary mb-8">Tu Carrito</h1>

        <c:choose>
            <c:when test="${not empty itemsCarrito}">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                    <!-- ---- LISTA DE ÍTEMS ---- -->
                    <div class="lg:col-span-2 space-y-4" id="cart-items-list">
                        <c:forEach var="item" items="${itemsCarrito}">
                            <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-4"
                                 id="cart-item-${item.product.id}">

                                <!-- Layout responsive: stack en móvil, row en desktop -->
                                <div class="flex flex-col sm:flex-row gap-4">

                                    <!-- Imagen del producto -->
                                    <a href="${contextPath}/producto/${item.product.id}" class="flex-shrink-0">
                                        <img src="${contextPath}/${item.product.imagenPath}"
                                             alt="${item.product.nombre}"
                                             class="w-full sm:w-20 h-32 sm:h-20 object-cover rounded mix-blend-luminosity hover:mix-blend-normal transition-all"
                                             loading="lazy">
                                    </a>

                                    <!-- Datos del producto + controles -->
                                    <div class="flex-grow min-w-0">
                                        <h4 class="font-label-md text-primary font-bold mb-1 leading-tight">
                                            <a href="${contextPath}/producto/${item.product.id}"
                                               class="hover:text-primary-fixed transition-colors">
                                                ${item.product.nombre}
                                            </a>
                                        </h4>
                                        <p class="font-label-sm text-on-surface-variant text-sm mb-1 flex flex-wrap gap-x-2 gap-y-1">
                                            <span>${item.product.precioFormateado} c/u</span>
                                            <span class="font-mono text-xs text-primary-fixed/80">⚖️ ${item.product.pesoDual}</span>
                                        </p>

                                        <!-- Controles de cantidad y eliminar -->
                                        <div class="flex flex-wrap items-center gap-3 mt-2">
                                            <form method="post" action="${contextPath}/app" class="flex items-center gap-2">
                                                <input type="hidden" name="accion" value="actualizarCarrito">
                                                <input type="hidden" name="productoId" value="${item.product.id}">
                                                <label for="cant-${item.product.id}" class="text-xs font-label-sm text-on-surface-variant whitespace-nowrap">Cant:</label>
                                                <input type="number"
                                                       id="cant-${item.product.id}"
                                                       name="cantidad"
                                                       value="${item.cantidad}"
                                                       min="1" max="99"
                                                       onchange="this.form.submit()"
                                                       class="w-16 bg-[#0A0A0A] border border-border-industrial text-center text-primary font-bold rounded py-1 px-2 focus:ring-1 focus:ring-primary-fixed focus:outline-none"
                                                       aria-label="Cantidad de ${item.product.nombre}">
                                                <button type="submit"
                                                        class="text-[11px] font-mono bg-surface-hover hover:bg-primary-fixed hover:text-black text-on-surface-variant px-2 py-1 rounded transition-colors whitespace-nowrap">
                                                    Actualizar
                                                </button>
                                            </form>

                                            <form method="post" action="${contextPath}/app" class="inline">
                                                <input type="hidden" name="accion" value="eliminarCarrito">
                                                <input type="hidden" name="productoId" value="${item.product.id}">
                                                <button type="submit"
                                                        class="text-on-surface-variant hover:text-error transition-colors flex items-center gap-1 text-xs"
                                                        aria-label="Eliminar ${item.product.nombre}">
                                                    <span class="material-symbols-outlined text-[18px]">delete</span>
                                                    <span>Eliminar</span>
                                                </button>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Subtotal del ítem — columna derecha en desktop -->
                                    <div class="flex sm:flex-col items-center sm:items-end justify-between sm:justify-start flex-shrink-0 pt-3 sm:pt-0 border-t sm:border-0 border-border-industrial">
                                        <p class="font-label-md text-primary-fixed font-bold text-right">${item.subtotalFormateado}</p>
                                        <c:if test="${item.cantidad >= 3}">
                                            <span class="font-label-sm text-xs text-green-400 mt-1 text-right">
                                                🏷 Desc. mayorista
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Vaciar carrito -->
                        <form method="post" action="${contextPath}/app"
                              onsubmit="return confirm('¿Seguro que deseas vaciar el carrito?')">
                            <input type="hidden" name="accion" value="vaciarCarrito">
                            <button type="submit"
                                    class="font-label-sm text-on-surface-variant hover:text-error transition-colors underline text-sm"
                                    id="btn-vaciar-carrito">
                                Vaciar carrito completo
                            </button>
                        </form>
                    </div>

                    <!-- ---- PANEL DE RESUMEN / CHECKOUT ---- -->
                    <div class="lg:col-span-1">
                        <form method="post" action="${contextPath}/checkout" id="checkout-form"
                              class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-6 space-y-4 lg:sticky lg:top-24">

                            <h2 class="font-headline-md text-primary">Resumen</h2>

                            <!-- Subtotal -->
                            <div class="flex justify-between items-center gap-4">
                                <span class="font-label-md text-on-surface-variant flex-shrink-0">Subtotal</span>
                                <span class="font-headline-md text-primary text-right break-all" id="cart-subtotal">
                                    <fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true" maxFractionDigits="0" />
                                    COP
                                </span>
                            </div>

                            <!-- Selector de envío -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant block" for="modalidad-envio">
                                    Modalidad de Envío
                                </label>
                                <select class="w-full bg-[#0A0A0A] border border-border-industrial text-on-surface font-body-md rounded px-3 py-2
                                               focus:ring-2 focus:ring-primary-fixed"
                                        name="modalidadEnvio"
                                        id="modalidad-envio"
                                        onchange="calcularTotalEnvio(this.value)">
                                    <option value="local"    ${envioSugerido == 'local' ? 'selected' : ''}>Recoger en Local — $ 0</option>
                                    <option value="estandar" ${envioSugerido == 'estandar' ? 'selected' : ''}>Envío Estándar — $ 25.000</option>
                                    <option value="express"  ${envioSugerido == 'express' ? 'selected' : ''}>Express — $ 50.000</option>
                                    <option value="pesado"   ${envioSugerido == 'pesado' ? 'selected' : ''}>Industrial Pesado — $ 150.000</option>
                                </select>
                            </div>

                            <!-- Costo de envío -->
                            <div class="flex justify-between items-center gap-4">
                                <span class="font-label-md text-on-surface-variant flex-shrink-0">Envío</span>
                                <span class="font-label-md text-primary-fixed text-right" id="envio-display">$ 0 COP</span>
                            </div>

                            <!-- Separador -->
                            <hr class="border-border-industrial">

                            <!-- Total -->
                            <div class="flex justify-between items-center gap-4">
                                <span class="font-headline-md text-primary flex-shrink-0">Total</span>
                                <span class="font-headline-md text-primary-fixed text-xl text-right break-all" id="total-display">
                                    <fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                                    COP
                                </span>
                            </div>

                            <!-- Peso estimado -->
                            <p class="text-xs text-on-surface-variant text-center font-label-sm">
                                ⚖️ Pedido: <fmt:formatNumber value="${pesoTotal}" maxFractionDigits="1"/> kg
                                (<fmt:formatNumber value="${pesoTotal * 2.20462}" maxFractionDigits="2"/> lbs)
                            </p>

                            <!-- Checkout button -->
                            <button type="submit"
                                    class="w-full bg-primary-fixed text-black font-label-md px-6 py-4 rounded-DEFAULT
                                           hover:bg-white transition-all duration-200 uppercase font-bold tracking-wider"
                                    id="checkout-btn">
                                Finalizar Compra →
                            </button>

                            <a href="${contextPath}/catalogo/equipamiento"
                               class="block w-full text-center bg-transparent border border-border-industrial text-on-surface
                                      font-label-md px-6 py-3 rounded-DEFAULT hover:border-primary-fixed
                                      hover:text-primary-fixed transition-colors uppercase text-sm"
                               id="btn-continuar-comprando">
                                Seguir Comprando
                            </a>
                        </form>
                    </div>
                </div>

            </c:when>
            <c:otherwise>
                <!-- ---- CARRITO VACÍO ---- -->
                <div class="flex flex-col items-center justify-center py-24 text-on-surface-variant" id="empty-cart">
                    <span class="material-symbols-outlined text-6xl mb-6 opacity-30">shopping_cart</span>
                    <h2 class="font-headline-md text-primary mb-3">Tu carrito está vacío</h2>
                    <p class="font-body-md mb-8">Explora nuestros productos y agrega los que necesitas.</p>
                    <div class="flex gap-4 flex-wrap justify-center">
                        <a href="${contextPath}/catalogo/equipamiento"
                           class="bg-primary-fixed text-black font-label-md px-8 py-4 rounded-DEFAULT hover:bg-white transition-all uppercase"
                           id="btn-explorar-equip">Equipamiento</a>
                        <a href="${contextPath}/catalogo/suplementos"
                           class="border border-border-industrial text-on-surface font-label-md px-8 py-4 rounded-DEFAULT hover:border-primary-fixed hover:text-primary-fixed transition-colors uppercase"
                           id="btn-explorar-supp">Suplementación</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

<script>
    /* Cálculo dinámico de total con tarifas de envío */
    const subtotalBase = ${subtotal};
    const tarifas = { local: 0, estandar: 25000, express: 50000, pesado: 150000 };

    function formatCOP(n) {
        return '$ ' + Math.round(n).toLocaleString('es-CO') + ' COP';
    }

    function calcularTotalEnvio(modalidad) {
        const envio = tarifas[modalidad] || 0;
        document.getElementById('envio-display').textContent = formatCOP(envio);
        document.getElementById('total-display').textContent = formatCOP(subtotalBase + envio);
    }

    // Inicializar con modalidad pre-seleccionada
    const sel = document.getElementById('modalidad-envio');
    if (sel) calcularTotalEnvio(sel.value);
</script>

<%@ include file="includes/footer.jsp" %>
