<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Inventario de Maquinaria Pesada" />
<%@ include file="includes/admin_header.jsp" %>

<!-- Header de Sección -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
    <div>
        <h1 class="font-display font-bold text-2xl lg:text-3xl text-white">Inventario de Maquinaria Pesada</h1>
        <p class="font-mono text-xs text-text-muted mt-1">Gestión de jaulas, prensas, poleas, precios al detal y reglas de venta mayorista.</p>
    </div>
    <button onclick="openModal('modal-maquina-crear')"
            class="bg-primary-fixed hover:bg-white text-black font-mono font-bold text-xs px-5 py-2.5 rounded flex items-center gap-2 transition-all shadow-lg shadow-primary-fixed/20 hover:scale-105">
        <span class="material-symbols-outlined text-sm font-bold">add</span>
        <span>Registrar Nueva Máquina</span>
    </button>
</div>

<!-- Tabla de Maquinaria -->
<div class="bg-surface-charcoal border border-border-industrial rounded overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left font-mono text-xs">
            <thead>
                <tr class="bg-[#131313] border-b border-border-industrial text-text-muted uppercase text-[10px] tracking-wider">
                    <th class="py-3.5 px-4">Equipo / Imagen</th>
                    <th class="py-3.5 px-4">Categoría</th>
                    <th class="py-3.5 px-4">Dimensiones &amp; Peso</th>
                    <th class="py-3.5 px-4">Precio Detal</th>
                    <th class="py-3.5 px-4">Descuento Mayorista</th>
                    <th class="py-3.5 px-4">Stock</th>
                    <th class="py-3.5 px-4 text-right">Acciones</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-border-industrial">
                <c:forEach items="${maquinas}" var="m">
                    <tr class="hover:bg-surface-hover transition-colors">
                        <td class="py-3.5 px-4">
                            <div class="flex items-center gap-3">
                                <img src="/${m.imagenPath}" alt="${m.nombre}"
                                     class="w-12 h-12 object-cover rounded border border-border-industrial bg-black"
                                     onerror="this.src='/assets/img/bento-pesada.jpg'">
                                <div>
                                    <div class="font-bold text-white">${m.nombre}</div>
                                    <div class="text-[10px] text-text-muted">ID: #KNX-EQ-${m.id}</div>
                                </div>
                            </div>
                        </td>
                        <td class="py-3.5 px-4">
                            <span class="bg-surface-card border border-border-industrial text-text-muted px-2 py-0.5 rounded uppercase text-[10px]">
                                ${m.categoria}
                            </span>
                        </td>
                        <td class="py-3.5 px-4 text-text-muted">
                            <div>📏 ${m.dimensiones}</div>
                            <div class="text-[10px] font-mono text-primary-fixed/90">⚖️ ${m.pesoDual}</div>
                        </td>
                        <td class="py-3.5 px-4 text-primary-fixed font-bold text-sm">
                            ${m.precioFormateado}
                        </td>
                        <td class="py-3.5 px-4">
                            <span class="bg-primary-fixed/10 border border-primary-fixed text-primary-fixed px-2 py-0.5 rounded text-[10px] font-semibold">
                                -${m.descuentoMayoristaPct}% (+3 un.)
                            </span>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${m.stock <= 5}">
                                    <span class="text-rogue-red font-bold flex items-center gap-1">
                                        <span class="w-2 h-2 rounded-full bg-rogue-red"></span>
                                        ${m.stock} un. (Bajo)
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-emerald-400 font-bold flex items-center gap-1">
                                        <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
                                        ${m.stock} un.
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-right space-x-2">
                            <button onclick="editarMaquina(${m.id}, '${m.nombre}', '${m.categoria}', ${m.precio}, ${m.pesoKg}, '${m.dimensiones}', ${m.stock}, ${m.descuentoMayoristaPct}, '${m.imagenPath}', '${m.descripcion}')"
                                    class="text-text-muted hover:text-primary-fixed p-1.5 rounded hover:bg-[#131313] transition-colors"
                                    title="Editar">
                                <span class="material-symbols-outlined text-sm">edit</span>
                            </button>
                            <form action="${contextPath}/admin" method="post" class="inline" onsubmit="return confirm('¿Eliminar esta máquina del catálogo?');">
                                <input type="hidden" name="accion" value="eliminarMaquina">
                                <input type="hidden" name="id" value="${m.id}">
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

<!-- Modal: Crear / Editar Maquinaria -->
<div id="modal-maquina-crear" class="admin-modal fixed inset-0 z-50 hidden items-center justify-center bg-black/80 backdrop-blur-sm p-4">
    <div class="bg-surface-charcoal border border-border-industrial rounded max-w-2xl w-full p-6 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between border-b border-border-industrial pb-4 mb-5">
            <h3 id="modal-title" class="font-display font-bold text-lg text-white">Registrar Maquinaria Pesada</h3>
            <button onclick="closeModal('modal-maquina-crear')" class="text-text-muted hover:text-white">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <form action="${contextPath}/admin" method="post" class="space-y-4 font-mono text-xs">
            <input type="hidden" name="accion" value="guardarMaquina">
            <input type="hidden" name="id" id="maq-id" value="0">

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">Nombre del Equipo *</label>
                    <input type="text" name="nombre" id="maq-nombre" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="Ej: Power Rack Pro X1">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Categoría *</label>
                    <select name="categoria" id="maq-categoria" required
                            class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none">
                        <option value="racks">Racks y Jaulas</option>
                        <option value="prensas">Prensas y Piernas</option>
                        <option value="poleas">Poleas y Cable</option>
                        <option value="smith">Máquinas Smith</option>
                        <option value="bancos">Bancos y Peso Libre</option>
                    </select>
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">Precio Detal (COP) *</label>
                    <input type="number" step="1000" name="precio" id="maq-precio" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="3500000">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Peso Físico (kg) *</label>
                    <input type="number" step="0.1" name="pesoKg" id="maq-peso" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="120">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Stock Disponible *</label>
                    <input type="number" name="stock" id="maq-stock" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="10">
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-text-muted mb-1">Dimensiones (LxAnxAl cm)</label>
                    <input type="text" name="dimensiones" id="maq-dimensiones"
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="210 x 140 x 230 cm">
                </div>
                <div>
                    <label class="block text-text-muted mb-1">Descuento Mayorista (%) *</label>
                    <input type="number" step="0.5" name="descuentoMayoristaPct" id="maq-descuento" required
                           class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                           placeholder="12.0">
                </div>
            </div>

            <div>
                <label class="block text-text-muted mb-1">Ruta de Foto / Imagen</label>
                <input type="text" name="imagenPath" id="maq-imagen"
                       class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                       placeholder="assets/img/eq-powerrack.jpg">
            </div>

            <div>
                <label class="block text-text-muted mb-1">Especificaciones Técnicas / Descripción</label>
                <textarea name="descripcion" id="maq-descripcion" rows="3"
                          class="w-full bg-[#0A0A0A] border border-border-industrial rounded px-3 py-2 text-white focus:border-primary-fixed focus:outline-none"
                          placeholder="Jaula con perfiles de acero estructural cal 11, recubrimiento electrostático..."></textarea>
            </div>

            <div class="flex items-center justify-end gap-3 pt-4 border-t border-border-industrial">
                <button type="button" onclick="closeModal('modal-maquina-crear')"
                        class="px-4 py-2 rounded bg-[#131313] hover:bg-surface-hover text-text-muted">
                    Cancelar
                </button>
                <button type="submit"
                        class="px-5 py-2 rounded bg-primary-fixed hover:bg-white text-black font-bold">
                    Guardar Máquina
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function editarMaquina(id, nombre, categoria, precio, peso, dimensiones, stock, descuento, imagen, desc) {
        document.getElementById('modal-title').textContent = 'Editar Maquinaria #' + id;
        document.getElementById('maq-id').value = id;
        document.getElementById('maq-nombre').value = nombre;
        document.getElementById('maq-categoria').value = categoria;
        document.getElementById('maq-precio').value = precio;
        document.getElementById('maq-peso').value = peso;
        document.getElementById('maq-dimensiones').value = dimensiones;
        document.getElementById('maq-stock').value = stock;
        document.getElementById('maq-descuento').value = descuento;
        document.getElementById('maq-imagen').value = imagen;
        document.getElementById('maq-descripcion').value = desc;
        openModal('modal-maquina-crear');
    }
</script>

<%@ include file="includes/admin_footer.jsp" %>
