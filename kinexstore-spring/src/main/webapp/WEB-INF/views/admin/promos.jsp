<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Marketing, Cupones y Promociones" />
<%@ include file="includes/admin_header.jsp" %>

<!-- Header de Sección -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
    <div>
        <h1 class="font-display font-bold text-2xl lg:text-3xl text-white">Marketing, Cupones &amp; Banners</h1>
        <p class="font-mono text-xs text-text-muted mt-1">Generador de cupones de descuento, fechas de vigencia y banners promocionales rotativos.</p>
    </div>
    <button onclick="openModal('modal-promo-crear')"
            class="bg-primary-fixed hover:bg-white text-black font-mono font-bold text-xs px-5 py-2.5 rounded flex items-center gap-2 transition-all shadow-lg shadow-primary-fixed/20 hover:scale-105">
        <span class="material-symbols-outlined text-sm font-bold">add</span>
        <span>Crear Promoción / Cupón</span>
    </button>
</div>

<!-- Tabla de Promociones y Cupones -->
<div class="bg-surface-charcoal border border-border-industrial rounded overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left font-mono text-xs">
            <thead>
                <tr class="bg-[#131313] border-b border-border-industrial text-text-muted uppercase text-[10px] tracking-wider">
                    <th class="py-3.5 px-4">Código / Tipo</th>
                    <th class="py-3.5 px-4">Campaña / Descripción</th>
                    <th class="py-3.5 px-4">Descuento</th>
                    <th class="py-3.5 px-4">Compra Mínima</th>
                    <th class="py-3.5 px-4">Vigencia</th>
                    <th class="py-3.5 px-4">Estado</th>
                    <th class="py-3.5 px-4 text-right">Acciones</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-border-industrial">
                <c:forEach items="${promociones}" var="pr">
                    <tr class="hover:bg-surface-hover transition-colors">
                        <td class="py-3.5 px-4">
                            <span class="bg-primary-fixed/10 border border-primary-fixed text-primary-fixed font-bold text-sm px-2.5 py-1 rounded">
                                ${pr.codigo}
                            </span>
                            <div class="text-[10px] text-text-muted mt-1 uppercase">${pr.tipo}</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <div class="font-bold text-white">${pr.titulo}</div>
                            <div class="text-[10px] text-text-muted">${pr.subtitulo}</div>
                        </td>
                        <td class="py-3.5 px-4 text-primary-fixed font-bold text-sm">
                            <c:choose>
                                <c:when test="${pr.porcentajeDescuento > 0}">
                                    -${pr.porcentajeDescuento}% OFF
                                </c:when>
                                <c:otherwise>
                                    Banner Promocional
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-text-muted">
                            <c:choose>
                                <c:when test="${pr.compraMinimaCOP > 0}">
                                    $ <fmt:formatNumber value="${pr.compraMinimaCOP}" type="number" groupingUsed="true" maxFractionDigits="0" /> COP
                                </c:when>
                                <c:otherwise>Sin Mínimo</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-text-muted text-[11px]">
                            <div>Hasta: ${pr.fechaFin}</div>
                            <c:choose>
                                <c:when test="${pr.estaVigente()}">
                                    <span class="text-emerald-400 font-bold">Vigente</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-rogue-red font-bold">Expirado</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${pr.activa}">
                                    <span class="bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 text-[10px] px-2 py-0.5 rounded font-bold">
                                        ACTIVA
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bg-surface-card border border-border-industrial text-text-muted text-[10px] px-2 py-0.5 rounded">
                                        PAUSADA
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-right space-x-2">
                            <form action="${contextPath}/admin" method="post" class="inline">
                                <input type="hidden" name="accion" value="togglePromo">
                                <input type="hidden" name="id" value="${pr.id}">
                                <button type="submit" class="text-text-muted hover:text-primary-fixed p-1.5 rounded hover:bg-[#131313] transition-colors"
                                        title="${pr.activa ? 'Pausar' : 'Activar'}">
                                    <span class="material-symbols-outlined text-sm">${pr.activa ? 'pause' : 'play_arrow'}</span>
                                </button>
                            </form>

                            <form action="${contextPath}/admin" method="post" class="inline" onsubmit="return confirm('¿Eliminar esta promoción?');">
                                <input type="hidden" name="accion" value="eliminarPromo">
                                <input type="hidden" name="id" value="${pr.id}">
                                <button type="submit" class="text-text-muted hover:text-rogue-red p-1.5 rounded hover:bg-[#131313] transition-colors" title="Eliminar">
                                    <span class="material-symbols-outlined text-sm">delete</span>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal: Crear Promoción / Cupón -->
<div id="modal-promo-crear" class="admin-modal fixed inset-0 z-50 hidden items-center justify-center bg-black/80 backdrop-blur-sm p-4">
    <div class="bg-surface-charcoal border border-border-industrial rounded max-w-xl w-full p-6 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between border-b border-border-industrial pb-4 mb-5">
            <h3 class="font-display font-bold text-lg text-white">Generar Nuevo Cupón o Campaña</h3>
            <button onclick="closeModal('modal-promo-crear')" class="text-text-muted hover:text-white">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${contextPath}/admin" method="post" class="space-y-4 font-mono text-xs">
            <input type="hidden" name="accion" value="guardarPromo">
            <input type="hidden" name="id" value="0">

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">Código Promocional *</label>
                    <input type="text" name="codigo" required uppercase
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-primary-fixed font-bold focus:border-primary-fixed focus:outline-none uppercase"
                           placeholder="Ej: GYM2026">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Tipo de Promoción *</label>
                    <select name="tipo" required
                            class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none">
                        <option value="CUPON">Cupón de Descuento</option>
                        <option value="BANNER_HERO">Banner Hero Rotativo</option>
                        <option value="BANNER_SECCION">Banner Promocional Sección</option>
                    </select>
                </div>
            </div>

            <div>
                <label class="block text-text-muted mb-1">Título de Campaña *</label>
                <input type="text" name="titulo" required
                       class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                       placeholder="Ej: Descuento Atletas de Élite">
            </div>

            <div>
                <label class="block text-text-muted mb-1">Descripción / Subtítulo</label>
                <input type="text" name="subtitulo"
                       class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                       placeholder="15% de descuento en pedidos superiores a $500.000 COP">
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">% Descuento</label>
                    <input type="number" step="0.5" name="porcentajeDescuento"
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="15.0">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Compra Mínima (COP)</label>
                    <input type="number" step="10000" name="compraMinimaCOP"
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="500000">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Fecha Límite</label>
                    <input type="date" name="fechaFin"
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none">
                </div>
            </div>

            <div class="flex items-center justify-end gap-3 pt-4 border-t border-border-industrial">
                <button type="button" onclick="closeModal('modal-promo-crear')"
                        class="px-4 py-2 rounded bg-[#131313] hover:bg-surface-hover text-text-muted">
                    Cancelar
                </button>
                <button type="submit"
                        class="px-5 py-2 rounded bg-primary-fixed hover:bg-white text-black font-bold">
                    Crear Cupón / Banner
                </button>
            </div>
        </form>
    </div>
</div>

<%@ include file="includes/admin_footer.jsp" %>
