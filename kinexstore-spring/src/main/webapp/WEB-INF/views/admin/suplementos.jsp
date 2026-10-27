<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Inventario de Suplementación y Lotes" />
<%@ include file="includes/admin_header.jsp" %>

<!-- Header de Sección -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
    <div>
        <h1 class="font-display font-bold text-2xl lg:text-3xl text-white">Inventario de Suplementación &amp; Lotes</h1>
        <p class="font-mono text-xs text-text-muted mt-1">Control de caducidad, registro sanitario INVIMA y seguimiento de stock por lote.</p>
    </div>
    <button onclick="openModal('modal-suplemento-crear')"
            class="bg-primary-fixed hover:bg-white text-black font-mono font-bold text-xs px-5 py-2.5 rounded flex items-center gap-2 transition-all shadow-lg shadow-primary-fixed/20 hover:scale-105">
        <span class="material-symbols-outlined text-sm font-bold">add</span>
        <span>Registrar Suplemento / Lote</span>
    </button>
</div>

<!-- Tabla de Suplementos -->
<div class="bg-surface-charcoal border border-border-industrial rounded overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left font-mono text-xs">
            <thead>
                <tr class="bg-[#131313] border-b border-border-industrial text-text-muted uppercase text-[10px] tracking-wider">
                    <th class="py-3.5 px-4">Suplemento</th>
                    <th class="py-3.5 px-4">Categoría / Registro</th>
                    <th class="py-3.5 px-4">Lote</th>
                    <th class="py-3.5 px-4">Vencimiento &amp; Estado</th>
                    <th class="py-3.5 px-4">Precio Detal</th>
                    <th class="py-3.5 px-4">Stock</th>
                    <th class="py-3.5 px-4 text-right">Acciones</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-border-industrial">
                <c:forEach items="${suplementos}" var="s">
                    <tr class="hover:bg-surface-hover transition-colors">
                        <td class="py-3.5 px-4">
                            <div class="flex items-center gap-3">
                                <img src="/${s.imagenPath}" alt="${s.nombre}"
                                     class="w-12 h-12 object-cover rounded border border-border-industrial bg-black"
                                     onerror="this.src='/assets/img/bento-suplementacion.jpg'">
                                <div>
                                    <div class="font-bold text-white">${s.nombre}</div>
                                    <div class="text-[10px] text-text-muted">${s.pesoKg} kg / Envase</div>
                                </div>
                            </div>
                        </td>
                        <td class="py-3.5 px-4">
                            <div class="text-white capitalize">${s.categoria}</div>
                            <div class="text-[10px] text-text-muted font-semibold">${s.registroInvima}</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <span class="bg-[#131313] border border-border-industrial px-2 py-0.5 rounded text-[11px] text-primary-fixed">
                                ${s.numeroLote}
                            </span>
                        </td>
                        <td class="py-3.5 px-4">
                            <div>${s.fechaVencimiento != null ? s.fechaVencimiento : '2027-12-31'}</div>
                            <c:set var="cadBadge" value="${s.estadoCaducidadBadge}" />
                            <c:choose>
                                <c:when test="${cadBadge == 'VENCIDO'}">
                                    <span class="bg-rogue-red/20 text-rogue-red border border-rogue-red text-[10px] px-2 py-0.5 rounded font-bold">
                                        ❌ Vencido
                                    </span>
                                </c:when>
                                <c:when test="${cadBadge == 'PROXIMO_A_VENCER'}">
                                    <span class="bg-amber-500/20 text-amber-400 border border-amber-500/40 text-[10px] px-2 py-0.5 rounded font-bold">
                                        ⚠️ Próx. a vencer (${s.diasParaVencer}d)
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 text-[10px] px-2 py-0.5 rounded font-bold">
                                        ✓ Óptimo (${s.diasParaVencer}d)
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-primary-fixed font-bold text-sm">
                            ${s.precioFormateado}
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${s.stock <= 5}">
                                    <span class="text-rogue-red font-bold">${s.stock} un. (Crítico)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-emerald-400 font-bold">${s.stock} un.</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-right space-x-2">
                            <button onclick="editarSuplemento(${s.id}, '${s.nombre}', '${s.categoria}', ${s.precio}, ${s.pesoKg}, ${s.stock}, '${s.numeroLote}', '${s.fechaVencimiento}', '${s.registroInvima}', '${s.imagenPath}', '${s.descripcion}')"
                                    class="text-text-muted hover:text-primary-fixed p-1.5 rounded hover:bg-[#131313] transition-colors"
                                    title="Editar">
                                <span class="material-symbols-outlined text-sm">edit</span>
                            </button>
                            <form action="${contextPath}/admin" method="post" class="inline" onsubmit="return confirm('¿Eliminar este suplemento?');">
                                <input type="hidden" name="accion" value="eliminarSuplemento">
                                <input type="hidden" name="id" value="${s.id}">
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

<!-- Modal: Crear / Editar Suplemento -->
<div id="modal-suplemento-crear" class="admin-modal fixed inset-0 z-50 hidden items-center justify-center bg-black/80 backdrop-blur-sm p-4">
    <div class="bg-surface-charcoal border border-border-industrial rounded max-w-2xl w-full p-6 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between border-b border-border-industrial pb-4 mb-5">
            <h3 id="modal-supp-title" class="font-display font-bold text-lg text-white">Registrar Suplemento / Lote</h3>
            <button onclick="closeModal('modal-suplemento-crear')" class="text-text-muted hover:text-white">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${contextPath}/admin" method="post" class="space-y-4 font-mono text-xs">
            <input type="hidden" name="accion" value="guardarSuplemento">
            <input type="hidden" name="id" id="supp-id" value="0">

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">Nombre del Suplemento *</label>
                    <input type="text" name="nombre" id="supp-nombre" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="Ej: Whey Protein Isolate 2kg">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Categoría *</label>
                    <select name="categoria" id="supp-categoria" required
                            class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none">
                        <option value="proteinas">Proteínas / Isolate</option>
                        <option value="creatinas">Creatinas Micronizadas</option>
                        <option value="preentrenos">Pre-Entrenos</option>
                        <option value="aminoacidos">Aminoácidos / BCAA</option>
                        <option value="salud">Salud &amp; Bienestar (Omega 3)</option>
                    </select>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">Precio Detal (COP) *</label>
                    <input type="number" step="1000" name="precio" id="supp-precio" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="260000">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Peso Neto (kg) *</label>
                    <input type="number" step="0.1" name="pesoKg" id="supp-peso" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="2.0">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Stock Disponible *</label>
                    <input type="number" name="stock" id="supp-stock" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="50">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">Número de Lote *</label>
                    <input type="text" name="numeroLote" id="supp-lote" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="LOT-WHEY-2026B">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Fecha de Vencimiento *</label>
                    <input type="date" name="fechaVencimiento" id="supp-vencimiento" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Registro Sanitario INVIMA *</label>
                    <input type="text" name="registroInvima" id="supp-invima" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="RSA-0019281">
                </div>
            </div>

            <div>
                <label class="block text-text-muted mb-1">Ruta de Foto / Imagen</label>
                <input type="text" name="imagenPath" id="supp-imagen"
                       class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                       placeholder="assets/img/supp-whey.jpg">
            </div>

            <div>
                <label class="block text-text-muted mb-1">Tabla Nutricional / Descripción</label>
                <textarea name="descripcion" id="supp-descripcion" rows="3"
                          class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                          placeholder="27g de proteína por porción, 0g azúcar, enriquecido con BCAAs..."></textarea>
            </div>

            <div class="flex items-center justify-end gap-3 pt-4 border-t border-border-industrial">
                <button type="button" onclick="closeModal('modal-suplemento-crear')"
                        class="px-4 py-2 rounded bg-[#131313] hover:bg-surface-hover text-text-muted">
                    Cancelar
                </button>
                <button type="submit"
                        class="px-5 py-2 rounded bg-primary-fixed hover:bg-white text-black font-bold">
                    Guardar Suplemento
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function editarSuplemento(id, nombre, categoria, precio, peso, stock, lote, vencimiento, invima, imagen, desc) {
        document.getElementById('modal-supp-title').textContent = 'Editar Suplemento #' + id;
        document.getElementById('supp-id').value = id;
        document.getElementById('supp-nombre').value = nombre;
        document.getElementById('supp-categoria').value = categoria;
        document.getElementById('supp-precio').value = precio;
        document.getElementById('supp-peso').value = peso;
        document.getElementById('supp-stock').value = stock;
        document.getElementById('supp-lote').value = lote;
        document.getElementById('supp-vencimiento').value = vencimiento;
        document.getElementById('supp-invima').value = invima;
        document.getElementById('supp-imagen').value = imagen;
        document.getElementById('supp-descripcion').value = desc;
        openModal('modal-suplemento-crear');
    }
</script>

<%@ include file="includes/admin_footer.jsp" %>
