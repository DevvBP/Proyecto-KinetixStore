<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Gestión de Pedidos y Logística" />
<%@ include file="includes/admin_header.jsp" %>

<!-- Header de Sección -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
    <div>
        <h1 class="font-display font-bold text-2xl lg:text-3xl text-white">Gestión de Pedidos &amp; Logística</h1>
        <p class="font-mono text-xs text-text-muted mt-1">Bandeja de despacho, estados de orden, transportadoras de carga pesada y guías.</p>
    </div>
</div>

<!-- Filtros de Estado -->
<div class="flex flex-wrap items-center gap-2 mb-6 font-mono text-xs">
    <a href="${contextPath}/admin?accion=gestionarPedidos"
       class="px-3.5 py-1.5 rounded border transition-all ${empty filtroActual ? 'bg-primary-fixed text-black font-bold border-primary-fixed' : 'bg-surface-charcoal text-text-muted border-border-industrial hover:text-white'}">
        Todos
    </a>
    <a href="${contextPath}/admin?accion=gestionarPedidos&filtroEstado=PENDIENTE"
       class="px-3.5 py-1.5 rounded border transition-all ${filtroActual == 'PENDIENTE' ? 'bg-secondary text-black font-bold border-secondary' : 'bg-surface-charcoal text-text-muted border-border-industrial hover:text-white'}">
        Pendientes
    </a>
    <a href="${contextPath}/admin?accion=gestionarPedidos&filtroEstado=EMPACADO"
       class="px-3.5 py-1.5 rounded border transition-all ${filtroActual == 'EMPACADO' ? 'bg-primary-fixed text-black font-bold border-primary-fixed' : 'bg-surface-charcoal text-text-muted border-border-industrial hover:text-white'}">
        Empacados
    </a>
    <a href="${contextPath}/admin?accion=gestionarPedidos&filtroEstado=EN_TRANSITO"
       class="px-3.5 py-1.5 rounded border transition-all ${filtroActual == 'EN_TRANSITO' ? 'bg-sky-400 text-black font-bold border-sky-400' : 'bg-surface-charcoal text-text-muted border-border-industrial hover:text-white'}">
        En Tránsito
    </a>
    <a href="${contextPath}/admin?accion=gestionarPedidos&filtroEstado=ENTREGADO"
       class="px-3.5 py-1.5 rounded border transition-all ${filtroActual == 'ENTREGADO' ? 'bg-emerald-400 text-black font-bold border-emerald-400' : 'bg-surface-charcoal text-text-muted border-border-industrial hover:text-white'}">
        Entregados
    </a>
</div>

<!-- Tabla de Pedidos -->
<div class="bg-surface-charcoal border border-border-industrial rounded overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left font-mono text-xs">
            <thead>
                <tr class="bg-[#131313] border-b border-border-industrial text-text-muted uppercase text-[10px] tracking-wider">
                    <th class="py-3.5 px-4">No. Orden</th>
                    <th class="py-3.5 px-4">Cliente &amp; Destino</th>
                    <th class="py-3.5 px-4">Tipo Logística</th>
                    <th class="py-3.5 px-4">Transportadora &amp; Guía</th>
                    <th class="py-3.5 px-4">Monto Total</th>
                    <th class="py-3.5 px-4">Estado</th>
                    <th class="py-3.5 px-4 text-right">Acción</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-border-industrial">
                <c:forEach items="${pedidos}" var="o">
                    <tr class="hover:bg-surface-hover transition-colors">
                        <td class="py-3.5 px-4 font-bold text-white">
                            <div>${o.numeroOrden}</div>
                            <div class="text-[10px] text-text-muted font-normal">${o.fechaCreacion.toString().substring(0,10)}</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <div class="text-white font-semibold">${o.clienteNombre}</div>
                            <div class="text-[10px] text-text-muted">${o.ciudad} — ${o.direccionEnvio}</div>
                            <div class="text-[10px] text-text-muted">${o.clienteTelefono}</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${o.esCargaPesada}">
                                    <span class="bg-primary-fixed/10 border border-primary-fixed text-primary-fixed px-2 py-0.5 rounded text-[10px] font-bold">
                                        🚜 CARGA PESADA
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bg-surface-card border border-border-industrial text-text-muted px-2 py-0.5 rounded text-[10px]">
                                        📦 Paquetería Estándar
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4">
                            <div class="text-white font-semibold">${o.transportadora != null ? o.transportadora : 'Sin Asignar'}</div>
                            <div class="text-[10px] text-primary-fixed font-mono">${o.numeroGuia != null ? o.numeroGuia : 'Sin Guía'}</div>
                        </td>
                        <td class="py-3.5 px-4 text-primary-fixed font-bold text-sm">
                            ${o.totalFormateado}
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${o.estado == 'PENDIENTE'}">
                                    <span class="bg-secondary/20 text-secondary border border-secondary/40 text-[10px] px-2.5 py-1 rounded font-bold">
                                        PENDIENTE
                                    </span>
                                </c:when>
                                <c:when test="${o.estado == 'EMPACADO'}">
                                    <span class="bg-primary-fixed/20 text-primary-fixed border border-primary-fixed/40 text-[10px] px-2.5 py-1 rounded font-bold">
                                        EMPACADO
                                    </span>
                                </c:when>
                                <c:when test="${o.estado == 'EN_TRANSITO'}">
                                    <span class="bg-sky-500/20 text-sky-400 border border-sky-500/40 text-[10px] px-2.5 py-1 rounded font-bold">
                                        EN TRÁNSITO
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 text-[10px] px-2.5 py-1 rounded font-bold">
                                        ENTREGADO
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-right">
                            <button onclick="gestionarPedido(${o.id}, '${o.numeroOrden}', '${o.estado}', '${o.transportadora}', '${o.numeroGuia}', '${o.notasLogistica}')"
                                    class="bg-[#131313] hover:bg-primary-fixed hover:text-black text-white px-3 py-1.5 rounded border border-border-industrial transition-all"
                                    title="Actualizar Logística">
                                <span class="material-symbols-outlined text-sm align-middle">local_shipping</span>
                                <span class="ml-1">Actualizar</span>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal: Actualizar Estado y Logística de Pedido -->
<div id="modal-pedido" class="admin-modal fixed inset-0 z-50 hidden items-center justify-center bg-black/80 backdrop-blur-sm p-4">
    <div class="bg-surface-charcoal border border-border-industrial rounded max-w-lg w-full p-6">
        <div class="flex items-center justify-between border-b border-border-industrial pb-4 mb-5">
            <div>
                <h3 class="font-display font-bold text-lg text-white">Actualizar Despacho &amp; Logística</h3>
                <p id="modal-ped-sub" class="font-mono text-xs text-primary-fixed"></p>
            </div>
            <button onclick="closeModal('modal-pedido')" class="text-text-muted hover:text-white">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${contextPath}/admin" method="post" class="space-y-4 font-mono text-xs">
            <input type="hidden" name="accion" value="actualizarPedido">
            <input type="hidden" name="id" id="ped-id">

            <div>
                <label class="block text-text-muted mb-1">Estado del Pedido *</label>
                <select name="estado" id="ped-estado" required
                        class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none">
                    <option value="PENDIENTE">PENDIENTE (En preparación)</option>
                    <option value="EMPACADO">EMPACADO (Listo para despacho)</option>
                    <option value="EN_TRANSITO">EN TRÁNSITO (Con transportadora)</option>
                    <option value="ENTREGADO">ENTREGADO (Recibido por cliente)</option>
                    <option value="CANCELADO">CANCELADO</option>
                </select>
            </div>

            <div>
                <label class="block text-text-muted mb-1">Transportadora / Flota *</label>
                <input type="text" name="transportadora" id="ped-transportadora" required
                       class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                       placeholder="Ej: Kinex Heavy Freight / Servientrega">
            </div>

            <div>
                <label class="block text-text-muted mb-1">Número de Guía / Tracking *</label>
                <input type="text" name="numeroGuia" id="ped-guia" required
                       class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                       placeholder="Ej: KNX-LOG-99210">
            </div>

            <div>
                <label class="block text-text-muted mb-1">Notas de Logística / Manifiesto de Carga</label>
                <textarea name="notasLogistica" id="ped-notas" rows="3"
                          class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                          placeholder="Camión equipado con rampa hidráulica. Contactar previo a entrega."></textarea>
            </div>

            <div class="flex items-center justify-end gap-3 pt-4 border-t border-border-industrial">
                <button type="button" onclick="closeModal('modal-pedido')"
                        class="px-4 py-2 rounded bg-[#131313] hover:bg-surface-hover text-text-muted">
                    Cancelar
                </button>
                <button type="submit"
                        class="px-5 py-2 rounded bg-primary-fixed hover:bg-white text-black font-bold">
                    Guardar Cambios
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function gestionarPedido(id, num, estado, trans, guia, notas) {
        document.getElementById('ped-id').value = id;
        document.getElementById('modal-ped-sub').textContent = 'Orden ' + num;
        document.getElementById('ped-estado').value = estado;
        document.getElementById('ped-transportadora').value = trans || 'Kinex Heavy Freight';
        document.getElementById('ped-guia').value = guia || '';
        document.getElementById('ped-notas').value = notas || '';
        openModal('modal-pedido');
    }
</script>

<%@ include file="includes/admin_footer.jsp" %>
