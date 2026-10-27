<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ================================================================
     ADMIN INCLUDE: admin_sidebar.jsp
     Barra lateral fija de navegación del Back-Office.
     ================================================================ --%>
<aside id="admin-sidebar"
       class="w-64 bg-[#131313] border-r border-border-industrial fixed inset-y-0 left-0 z-50 flex flex-col transition-transform duration-300 -translate-x-full md:translate-x-0">

    <!-- Brand Header -->
    <div class="h-16 flex items-center justify-between px-6 border-b border-border-industrial">
        <a href="${contextPath}/admin?accion=dashboard" class="flex items-center gap-2.5">
            <span class="material-symbols-outlined text-primary-fixed text-2xl">fitness_center</span>
            <span class="font-display font-bold text-lg text-white tracking-tight">Kinex<span class="text-primary-fixed">Admin</span></span>
        </a>
        <span class="bg-primary-fixed/10 border border-primary-fixed text-primary-fixed font-mono text-[10px] px-1.5 py-0.5 rounded uppercase font-semibold">
            v1.0
        </span>
    </div>

    <!-- Navigation Menu -->
    <nav class="flex-1 px-4 py-6 space-y-1.5 overflow-y-auto font-mono text-xs" aria-label="Menú Administrativo">

        <div class="px-3 py-1 text-[10px] uppercase font-bold text-text-muted/60 tracking-wider">
            Métricas & Control
        </div>

        <!-- 1. Dashboard -->
        <a href="${contextPath}/admin?accion=dashboard"
           class="flex items-center gap-3 px-3 py-2.5 rounded transition-all duration-150 ${moduloActivo == 'dashboard' ? 'bg-primary-fixed text-black font-semibold shadow-lg shadow-primary-fixed/20' : 'text-text-muted hover:text-white hover:bg-surface-card'}">
            <span class="material-symbols-outlined text-lg">dashboard</span>
            <span>Dashboard</span>
        </a>

        <div class="pt-4 px-3 py-1 text-[10px] uppercase font-bold text-text-muted/60 tracking-wider">
            Gestión de Inventario
        </div>

        <!-- 2. Maquinaria Pesada -->
        <a href="${contextPath}/admin?accion=gestionarMaquinas"
           class="flex items-center gap-3 px-3 py-2.5 rounded transition-all duration-150 ${moduloActivo == 'maquinas' ? 'bg-primary-fixed text-black font-semibold shadow-lg shadow-primary-fixed/20' : 'text-text-muted hover:text-white hover:bg-surface-card'}">
            <span class="material-symbols-outlined text-lg">precision_manufacturing</span>
            <span>Maquinaria Pesada</span>
        </a>

        <!-- 3. Suplementación & Lotes -->
        <a href="${contextPath}/admin?accion=gestionarSuplementos"
           class="flex items-center gap-3 px-3 py-2.5 rounded transition-all duration-150 ${moduloActivo == 'suplementos' ? 'bg-primary-fixed text-black font-semibold shadow-lg shadow-primary-fixed/20' : 'text-text-muted hover:text-white hover:bg-surface-card'}">
            <span class="material-symbols-outlined text-lg">medication</span>
            <span>Suplementación &amp; Lotes</span>
        </a>

        <div class="pt-4 px-3 py-1 text-[10px] uppercase font-bold text-text-muted/60 tracking-wider">
            Operaciones & Clientes
        </div>

        <!-- 4. Pedidos & Logística -->
        <a href="${contextPath}/admin?accion=gestionarPedidos"
           class="flex items-center justify-between px-3 py-2.5 rounded transition-all duration-150 ${moduloActivo == 'pedidos' ? 'bg-primary-fixed text-black font-semibold shadow-lg shadow-primary-fixed/20' : 'text-text-muted hover:text-white hover:bg-surface-card'}">
            <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-lg">local_shipping</span>
                <span>Pedidos &amp; Fletes</span>
            </div>
        </a>

        <!-- 5. Planes de Entrenamiento -->
        <a href="${contextPath}/admin?accion=gestionarPlanes"
           class="flex items-center gap-3 px-3 py-2.5 rounded transition-all duration-150 ${moduloActivo == 'planes' ? 'bg-primary-fixed text-black font-semibold shadow-lg shadow-primary-fixed/20' : 'text-text-muted hover:text-white hover:bg-surface-card'}">
            <span class="material-symbols-outlined text-lg">assignment_ind</span>
            <span>Planes &amp; Rutinas</span>
        </a>

        <!-- 6. Directorio de Usuarios -->
        <a href="${contextPath}/admin?accion=gestionarUsuarios"
           class="flex items-center gap-3 px-3 py-2.5 rounded transition-all duration-150 ${moduloActivo == 'usuarios' ? 'bg-primary-fixed text-black font-semibold shadow-lg shadow-primary-fixed/20' : 'text-text-muted hover:text-white hover:bg-surface-card'}">
            <span class="material-symbols-outlined text-lg">manage_accounts</span>
            <span>Usuarios &amp; Roles</span>
        </a>

        <!-- 7. Marketing & Promociones -->
        <a href="${contextPath}/admin?accion=gestionarPromos"
           class="flex items-center gap-3 px-3 py-2.5 rounded transition-all duration-150 ${moduloActivo == 'promos' ? 'bg-primary-fixed text-black font-semibold shadow-lg shadow-primary-fixed/20' : 'text-text-muted hover:text-white hover:bg-surface-card'}">
            <span class="material-symbols-outlined text-lg">loyalty</span>
            <span>Marketing &amp; Cupones</span>
        </a>
    </nav>

    <!-- Footer de Sidebar con botón de tienda pública -->
    <div class="p-4 border-t border-border-industrial bg-[#0E0E0E]">
        <div class="flex items-center justify-between text-[11px] text-text-muted font-mono">
            <span>Servidor Tomcat 10+</span>
            <span class="flex items-center gap-1 text-primary-fixed font-bold">
                <span class="w-2 h-2 rounded-full bg-primary-fixed animate-ping"></span>
                ONLINE
            </span>
        </div>
    </div>
</aside>

<!-- Backdrop móvil -->
<div id="admin-sidebar-backdrop" class="fixed inset-0 bg-black/60 z-40 hidden md:hidden" onclick="toggleAdminSidebar()"></div>

<script>
    function toggleAdminSidebar() {
        const sidebar = document.getElementById('admin-sidebar');
        const backdrop = document.getElementById('admin-sidebar-backdrop');
        if (sidebar && backdrop) {
            sidebar.classList.toggle('-translate-x-full');
            backdrop.classList.toggle('hidden');
        }
    }
</script>
