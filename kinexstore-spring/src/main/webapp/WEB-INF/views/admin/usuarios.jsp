<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Gestión de Usuarios y Roles (RBAC)" />
<%@ include file="includes/admin_header.jsp" %>

<!-- Header de Sección -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
    <div>
        <h1 class="font-display font-bold text-2xl lg:text-3xl text-white">Directorio de Usuarios &amp; Roles</h1>
        <p class="font-mono text-xs text-text-muted mt-1">Control de acceso RBAC, asignación de permisos de Administrador y estado de cuenta.</p>
    </div>

    <!-- Buscador -->
    <form action="${contextPath}/admin" method="get" class="flex items-center gap-2">
        <input type="hidden" name="accion" value="gestionarUsuarios">
        <div class="relative">
            <input type="text" name="q" value="${busqueda}" placeholder="Buscar por nombre o email..."
                   class="bg-surface-charcoal border border-border-industrial rounded px-3 py-1.5 pl-8 text-xs font-mono text-white placeholder:text-text-muted focus:border-primary-fixed focus:outline-none w-64">
            <span class="material-symbols-outlined text-sm text-text-muted absolute left-2.5 top-2">search</span>
        </div>
        <button type="submit" class="bg-[#131313] hover:bg-surface-hover text-white border border-border-industrial px-3 py-1.5 rounded font-mono text-xs">
            Buscar
        </button>
    </form>
</div>

<!-- Tabla de Usuarios -->
<div class="bg-surface-charcoal border border-border-industrial rounded overflow-hidden">
    <div class="overflow-x-auto">
        <table class="w-full text-left font-mono text-xs">
            <thead>
                <tr class="bg-[#131313] border-b border-border-industrial text-text-muted uppercase text-[10px] tracking-wider">
                    <th class="py-3.5 px-4">Usuario / Nombre</th>
                    <th class="py-3.5 px-4">Correo Electrónico</th>
                    <th class="py-3.5 px-4">Teléfono &amp; Ubicación</th>
                    <th class="py-3.5 px-4">Rol Asignado</th>
                    <th class="py-3.5 px-4">Estado</th>
                    <th class="py-3.5 px-4 text-right">Acciones RBAC</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-border-industrial">
                <c:forEach items="${usuarios}" var="u">
                    <tr class="hover:bg-surface-hover transition-colors">
                        <td class="py-3.5 px-4">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-surface-card border border-border-industrial flex items-center justify-center font-bold text-white">
                                    ${u.nombre.substring(0,1)}
                                </div>
                                <div>
                                    <div class="font-bold text-white">${u.nombreCompleto}</div>
                                    <div class="text-[10px] text-text-muted">ID: #USR-${u.id}</div>
                                </div>
                            </div>
                        </td>
                        <td class="py-3.5 px-4 text-on-surface">
                            ${u.email}
                        </td>
                        <td class="py-3.5 px-4 text-text-muted">
                            <div>${u.telefono != null ? u.telefono : 'N/A'}</div>
                            <div class="text-[10px]">${u.direccion != null ? u.direccion : 'Colombia'}</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${u.esAdmin()}">
                                    <span class="bg-primary-fixed/20 text-primary-fixed border border-primary-fixed text-[10px] px-2.5 py-0.5 rounded font-bold">
                                        🛡️ ADMINISTRADOR
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bg-surface-card border border-border-industrial text-text-muted text-[10px] px-2.5 py-0.5 rounded">
                                        👤 CLIENTE
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${u.activo}">
                                    <span class="text-emerald-400 font-bold flex items-center gap-1">
                                        <span class="w-2 h-2 rounded-full bg-emerald-400"></span> Activo
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-rogue-red font-bold flex items-center gap-1">
                                        <span class="w-2 h-2 rounded-full bg-rogue-red"></span> Inactivo
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-right space-x-2">
                            <!-- Toggle Rol Admin -->
                            <form action="${contextPath}/admin" method="post" class="inline">
                                <input type="hidden" name="accion" value="cambiarRolUsuario">
                                <input type="hidden" name="id" value="${u.id}">
                                <c:choose>
                                    <c:when test="${u.esAdmin()}">
                                        <input type="hidden" name="nuevoRol" value="CLIENTE">
                                        <button type="submit" class="text-text-muted hover:text-amber-400 p-1.5 rounded hover:bg-[#131313] transition-colors"
                                                title="Revocar Admin" onclick="return confirm('¿Revocar permisos de administrador a este usuario?');">
                                            <span class="material-symbols-outlined text-sm">remove_moderator</span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="nuevoRol" value="ADMINISTRADOR">
                                        <button type="submit" class="text-text-muted hover:text-primary-fixed p-1.5 rounded hover:bg-[#131313] transition-colors"
                                                title="Hacer Administrador" onclick="return confirm('¿Convertir este usuario en Administrador?');">
                                            <span class="material-symbols-outlined text-sm">add_moderator</span>
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </form>

                            <!-- Toggle Estado Activo/Inactivo -->
                            <form action="${contextPath}/admin" method="post" class="inline">
                                <input type="hidden" name="accion" value="toggleEstadoUsuario">
                                <input type="hidden" name="id" value="${u.id}">
                                <button type="submit" class="text-text-muted hover:text-white p-1.5 rounded hover:bg-[#131313] transition-colors"
                                        title="${u.activo ? 'Desactivar Cuenta' : 'Activar Cuenta'}">
                                    <span class="material-symbols-outlined text-sm">${u.activo ? 'lock_open' : 'lock'}</span>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="includes/admin_footer.jsp" %>
