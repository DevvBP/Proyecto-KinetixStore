<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Confirmar Pedido — Checkout" />
<c:set var="pageDescription" value="Confirma los detalles de tu orden, dirección de entrega y método de envío en KinexStore." />
<%@ include file="includes/header.jsp" %>

    <div class="max-w-4xl mx-auto px-margin-mobile py-12" id="section-checkout">
        
        <div class="text-center mb-8">
            <span class="material-symbols-outlined text-4xl text-primary-fixed mb-2 block">verified_user</span>
            <h1 class="font-headline-lg text-primary mb-2">Finalizar Pedido</h1>
            <p class="font-body-md text-on-surface-variant">Revisa tu dirección de entrega y confirma tu compra segura</p>
        </div>

        <c:if test="${not empty errorCheckout}">
            <div class="mb-6 p-4 bg-error-container/20 border border-rogue-red rounded text-rogue-red font-label-md text-sm flex items-center gap-2" role="alert">
                <span class="material-symbols-outlined text-base">error</span>
                <span>${errorCheckout}</span>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- COLUMNA 1 Y 2: DATOS DE ENVÍO Y PRODUCTOS -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Tarjeta Dirección del Usuario -->
                <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-6">
                    <div class="flex justify-between items-center mb-4 pb-3 border-b border-border-industrial">
                        <h2 class="font-headline-md text-primary text-lg flex items-center gap-2">
                            <span class="material-symbols-outlined text-primary-fixed text-xl">location_on</span>
                            Destino de Envío
                        </h2>
                        <span class="bg-primary-fixed/10 border border-primary-fixed text-primary-fixed px-2.5 py-0.5 rounded text-xs font-mono">
                            Cliente Verificado
                        </span>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm font-body-md">
                        <div>
                            <span class="text-text-muted text-xs block">Destinatario:</span>
                            <span class="text-on-surface font-semibold">${usuario.nombreCompleto}</span>
                        </div>
                        <div>
                            <span class="text-text-muted text-xs block">Teléfono de Entrega:</span>
                            <span class="text-on-surface font-mono">${usuario.telefono}</span>
                        </div>
                        <div class="md:col-span-2">
                            <span class="text-text-muted text-xs block">Dirección Detallada:</span>
                            <span class="text-on-surface font-semibold text-base">${usuario.direccionDetallada}</span>
                        </div>
                        <div>
                            <span class="text-text-muted text-xs block">Ciudad / Departamento:</span>
                            <span class="text-on-surface">${usuario.ciudad}, ${usuario.estadoProvincia}</span>
                        </div>
                        <div>
                            <span class="text-text-muted text-xs block">País & Código Postal:</span>
                            <span class="text-on-surface">${usuario.pais} (${usuario.codigoPostal})</span>
                        </div>
                    </div>
                </div>

                <!-- Lista de Ítems a despachar -->
                <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-6">
                    <h2 class="font-headline-md text-primary text-lg mb-4 pb-3 border-b border-border-industrial flex items-center gap-2">
                        <span class="material-symbols-outlined text-primary-fixed text-xl">inventory_2</span>
                        Productos en tu Orden (${itemsCarrito.size()})
                    </h2>

                    <div class="space-y-4">
                        <c:forEach var="item" items="${itemsCarrito}">
                            <div class="flex items-center justify-between gap-4 py-2 border-b border-border-industrial/50 last:border-0">
                                <div class="flex items-center gap-3">
                                    <img src="${contextPath}/${item.product.imagenPath}"
                                         alt="${item.product.nombre}"
                                         class="w-12 h-12 object-cover rounded bg-black">
                                    <div>
                                        <h4 class="font-label-md text-primary font-bold text-sm">${item.product.nombre}</h4>
                                        <span class="text-xs text-text-muted">Cant: ${item.cantidad} · ⚖️ ${item.product.pesoDual} c/u</span>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <span class="font-mono text-primary-fixed font-bold text-sm">${item.subtotalFormateado}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- COLUMNA 3: RESUMEN FINANCIERO Y CONFIRMAR -->
            <div class="lg:col-span-1">
                <form method="post" action="${contextPath}/checkout" class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-6 space-y-5 sticky top-24">
                    <h2 class="font-headline-md text-primary text-lg pb-3 border-b border-border-industrial">Total a Pagar</h2>

                    <div class="space-y-3 text-sm">
                        <div class="flex justify-between items-center text-on-surface-variant">
                            <span>Subtotal Productos:</span>
                            <span class="font-mono text-primary font-semibold">
                                <fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true" maxFractionDigits="0"/> COP
                            </span>
                        </div>

                        <div class="flex justify-between items-center text-on-surface-variant">
                            <span>Modalidad Envío:</span>
                            <span class="font-mono uppercase text-xs text-primary-fixed">${envioSugerido}</span>
                        </div>

                        <div class="flex justify-between items-center text-on-surface-variant">
                            <span>Costo de Flete:</span>
                            <span class="font-mono text-primary font-semibold">
                                <fmt:formatNumber value="${costoEnvio}" type="number" groupingUsed="true" maxFractionDigits="0"/> COP
                            </span>
                        </div>

                        <div class="flex justify-between items-center pt-3 border-t border-border-industrial text-base font-bold">
                            <span class="text-primary">Total Facturado:</span>
                            <span class="font-mono text-primary-fixed text-lg">
                                <fmt:formatNumber value="${total}" type="number" groupingUsed="true" maxFractionDigits="0"/> COP
                            </span>
                        </div>

                        <p class="text-[11px] text-text-muted font-mono text-center pt-1">
                            ⚖️ Peso total: <fmt:formatNumber value="${pesoTotal}" maxFractionDigits="1"/> kg (<fmt:formatNumber value="${pesoTotal * 2.20462}" maxFractionDigits="2"/> lbs)
                        </p>
                    </div>

                    <input type="hidden" name="modalidadEnvio" value="${envioSugerido}">

                    <button type="submit"
                            class="w-full bg-primary-fixed text-black font-label-md py-4 rounded-DEFAULT
                                   hover:bg-white hover:shadow-xl hover:shadow-primary-fixed/40 transition-all
                                   uppercase font-bold tracking-wider text-sm flex items-center justify-center gap-2"
                            id="btn-confirmar-orden">
                        <span class="material-symbols-outlined text-lg">lock</span>
                        Confirmar y Pagar
                    </button>

                    <a href="${contextPath}/carrito"
                       class="block w-full text-center text-xs text-text-muted hover:text-primary-fixed transition-colors underline">
                        ← Regresar a editar el carrito
                    </a>
                </form>
            </div>
        </div>
    </div>

<%@ include file="includes/footer.jsp" %>
