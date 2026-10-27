<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Administración de Planes Personalizados" />
<%@ include file="includes/admin_header.jsp" %>

<!-- Header de Sección -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
    <div>
        <h1 class="font-display font-bold text-2xl lg:text-3xl text-white">Administración de Planes &amp; Rutinas</h1>
        <p class="font-mono text-xs text-text-muted mt-1">Asignación de entrenadores, elaboración de protocolos biomecánicos y entrega de PDFs.</p>
    </div>
</div>

<!-- Tabla de Solicitudes de Planes -->
<div class="bg-surface-charcoal border border-border-industrial rounded overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left font-mono text-xs">
            <thead>
                <tr class="bg-[#131313] border-b border-border-industrial text-text-muted uppercase text-[10px] tracking-wider">
                    <th class="py-3.5 px-4">Cliente / Contacto</th>
                    <th class="py-3.5 px-4">Perfil Atleta</th>
                    <th class="py-3.5 px-4">Objetivo Solicitado</th>
                    <th class="py-3.5 px-4">Entrenador Asignado</th>
                    <th class="py-3.5 px-4">Documento PDF / Protocolo</th>
                    <th class="py-3.5 px-4">Estado</th>
                    <th class="py-3.5 px-4 text-right">Acción</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-border-industrial">
                <c:forEach items="${planes}" var="pl">
                    <tr class="hover:bg-surface-hover transition-colors">
                        <td class="py-3.5 px-4">
                            <div class="font-bold text-white">${pl.clienteNombre}</div>
                            <div class="text-[10px] text-text-muted">${pl.clienteEmail}</div>
                            <div class="text-[10px] text-text-muted">${pl.clienteTelefono}</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <div>Nivel: <span class="text-primary-fixed font-semibold">${pl.nivel}</span></div>
                            <div class="text-text-muted text-[10px]">${pl.diasPorSemana} días / semana</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <span class="bg-surface-card border border-border-industrial text-white px-2 py-0.5 rounded text-[10px]">
                                ${pl.objetivo}
                            </span>
                        </td>
                        <td class="py-3.5 px-4 text-white font-semibold">
                            ${pl.entrenadorAsignado != null ? pl.entrenadorAsignado : 'Sin Asignar'}
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${not empty pl.archivoPdfNombre}">
                                    <span class="text-primary-fixed flex items-center gap-1">
                                        <span class="material-symbols-outlined text-sm">picture_as_pdf</span>
                                        <span class="underline">${pl.archivoPdfNombre}</span>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-text-muted italic">Pendiente de subir</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${pl.estado == 'PENDIENTE'}">
                                    <span class="bg-secondary/20 text-secondary border border-secondary/40 text-[10px] px-2 py-0.5 rounded font-bold">
                                        PENDIENTE
                                    </span>
                                </c:when>
                                <c:when test="${pl.estado == 'EN_ELABORACION'}">
                                    <span class="bg-amber-500/20 text-amber-400 border border-amber-500/40 text-[10px] px-2 py-0.5 rounded font-bold">
                                        EN ELABORACIÓN
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 text-[10px] px-2 py-0.5 rounded font-bold">
                                        ✓ ENTREGADO
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-right">
                            <button onclick="asignarPlanModal(${pl.id}, '${pl.clienteNombre}', '${pl.entrenadorAsignado}', '${pl.archivoPdfNombre}', '${pl.estado}', '${pl.rutinaDetalleTexto}', '${pl.dietaDetalleTexto}')"
                                    class="bg-[#131313] hover:bg-primary-fixed hover:text-black text-white px-3 py-1.5 rounded border border-border-industrial transition-all"
                                    title="Adjuntar / Asignar">
                                <span class="material-symbols-outlined text-sm align-middle">upload_file</span>
                                <span class="ml-1">Gestionar</span>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal: Asignar / Subir Plan -->
<div id="modal-plan" class="admin-modal fixed inset-0 z-50 hidden items-center justify-center bg-black/80 backdrop-blur-sm p-4">
    <div class="bg-surface-charcoal border border-border-industrial rounded max-w-2xl w-full p-6 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between border-b border-border-industrial pb-4 mb-5">
            <div>
                <h3 class="font-display font-bold text-lg text-white">Gestionar Plan Personalizado</h3>
                <p id="modal-plan-cliente" class="font-mono text-xs text-primary-fixed"></p>
            </div>
            <button onclick="closeModal('modal-plan')" class="text-text-muted hover:text-white">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${contextPath}/admin" method="post" class="space-y-4 font-mono text-xs">
            <input type="hidden" name="accion" value="asignarPlan">
            <input type="hidden" name="id" id="plan-id">

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">Entrenador / Especialista *</label>
                    <input type="text" name="entrenadorAsignado" id="plan-entrenador" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="Ej: Coach Mateo Silva (Biomecánica)">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Estado de Entrega *</label>
                    <select name="estado" id="plan-estado" required
                            class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none">
                        <option value="PENDIENTE">PENDIENTE (Esperando especialista)</option>
                        <option value="EN_ELABORACION">EN ELABORACIÓN (Diseñando rutina)</option>
                        <option value="ENTREGADO">ENTREGADO (Publicado al cliente)</option>
                        <option value="REVISION">REVISIÓN (Solicitud de ajuste)</option>
                    </select>
                </div>
            </div>

            <div>
                <label class="block text-text-muted mb-1">Nombre de Archivo PDF Adjunto</label>
                <input type="text" name="archivoPdfNombre" id="plan-pdf"
                       class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                       placeholder="Ej: Plan_Hipertrofia_Carlos_2026.pdf">
                <p class="text-[10px] text-text-muted mt-1">El cliente podrá descargar este PDF directamente desde su dashboard.</p>
            </div>

            <div>
                <label class="block text-text-muted mb-1">Detalle de Rutina y Split de Entrenamiento</label>
                <textarea name="rutinaDetalleTexto" id="plan-rutina" rows="3"
                          class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                          placeholder="Día 1: Empuje (Pecho/Hombro/Tríceps)..."></textarea>
            </div>

            <div>
                <label class="block text-text-muted mb-1">Pautas Nutricionales &amp; Macronutrientes</label>
                <textarea name="dietaDetalleTexto" id="plan-dieta" rows="2"
                          class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                          placeholder="Requerimiento calórico: 2.800 kcal / 160g Proteína..."></textarea>
            </div>

            <div class="flex items-center justify-end gap-3 pt-4 border-t border-border-industrial">
                <button type="button" onclick="closeModal('modal-plan')"
                        class="px-4 py-2 rounded bg-[#131313] hover:bg-surface-hover text-text-muted">
                    Cancelar
                </button>
                <button type="submit"
                        class="px-5 py-2 rounded bg-primary-fixed hover:bg-white text-black font-bold">
                    Guardar y Notificar al Cliente
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function asignarPlanModal(id, cliente, entrenador, pdf, estado, rutina, dieta) {
        document.getElementById('plan-id').value = id;
        document.getElementById('modal-plan-cliente').textContent = 'Cliente: ' + cliente;
        document.getElementById('plan-entrenador').value = entrenador || '';
        document.getElementById('plan-pdf').value = pdf || '';
        document.getElementById('plan-estado').value = estado;
        document.getElementById('plan-rutina').value = rutina || '';
        document.getElementById('plan-dieta').value = dieta || '';
        openModal('modal-plan');
    }
</script>

<%@ include file="includes/admin_footer.jsp" %>
