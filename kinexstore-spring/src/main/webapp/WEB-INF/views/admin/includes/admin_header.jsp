<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- ================================================================
     ADMIN INCLUDE: admin_header.jsp
     Cabecera superior del panel administrativo Back-Office.
     Variables: moduloActivo, sessionScope.usuarioActual, pageTitle
     ================================================================ --%>
<!DOCTYPE html>
<html class="dark" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty pageTitle}">${pageTitle} — KinexStore Back-Office</c:when>
            <c:otherwise>KinexStore Admin Suite</c:otherwise>
        </c:choose>
    </title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary-fixed": "#c3f400",
                        "primary-fixed-dim": "#abd600",
                        "border-industrial": "#333333",
                        "surface-charcoal": "#1A1A1A",
                        "surface-dark": "#131313",
                        "surface-card": "#201f1f",
                        "surface-hover": "#2a2a2a",
                        "text-muted": "#A1A1A1",
                        "rogue-red": "#D11919",
                        "error-container": "#93000a",
                        "on-surface": "#e5e2e1"
                    },
                    fontFamily: {
                        "display": ["IBM Plex Sans"],
                        "body": ["Inter"],
                        "mono": ["JetBrains Mono"]
                    }
                }
            }
        }
    </script>
    <link rel="stylesheet" href="${contextPath}/assets/css/styles.css">
</head>
<body class="bg-[#0A0A0A] text-on-surface antialiased min-h-screen flex font-body selection:bg-primary-fixed selection:text-black overflow-x-hidden">

    <!-- Mensajes Flash de Administración -->
    <c:if test="${not empty param.msg}">
        <div id="admin-flash" class="fixed top-5 right-5 z-[300] bg-primary-fixed text-black font-mono text-sm px-6 py-3 rounded shadow-2xl shadow-primary-fixed/30 flex items-center gap-3 animate-bounce">
            <span class="material-symbols-outlined text-lg">check_circle</span>
            <span>
                <c:choose>
                    <c:when test="${param.msg == 'maquina_guardada'}">✓ Maquinaria guardada correctamente</c:when>
                    <c:when test="${param.msg == 'maquina_eliminada'}">✓ Maquinaria eliminada del inventario</c:when>
                    <c:when test="${param.msg == 'suplemento_guardado'}">✓ Suplemento y lote registrados</c:when>
                    <c:when test="${param.msg == 'suplemento_eliminado'}">✓ Suplemento eliminado</c:when>
                    <c:when test="${param.msg == 'pedido_actualizado'}">✓ Estado y guía de pedido actualizados</c:when>
                    <c:when test="${param.msg == 'plan_actualizado'}">✓ Rutina y asignación de plan enviada</c:when>
                    <c:when test="${param.msg == 'rol_actualizado'}">✓ Rol de usuario actualizado exitosamente</c:when>
                    <c:when test="${param.msg == 'usuario_estado_actualizado'}">✓ Estado del usuario modificado</c:when>
                    <c:when test="${param.msg == 'promo_guardada'}">✓ Cupón/Banner guardado correctamente</c:when>
                    <c:when test="${param.msg == 'promo_actualizada'}">✓ Estado de promoción modificado</c:when>
                    <c:when test="${param.msg == 'promo_eliminada'}">✓ Promoción eliminada</c:when>
                    <c:when test="${param.msg == 'admin_bienvenido'}">Bienvenido al Panel de Control KinexStore</c:when>
                    <c:otherwise>${param.msg}</c:otherwise>
                </c:choose>
            </span>
        </div>
        <script>setTimeout(() => document.getElementById('admin-flash')?.remove(), 4000);</script>
    </c:if>

    <c:if test="${not empty param.error}">
        <div id="admin-flash-err" class="fixed top-5 right-5 z-[300] bg-error-container text-white font-mono text-sm px-6 py-3 rounded shadow-2xl border border-rogue-red flex items-center gap-3">
            <span class="material-symbols-outlined text-lg">error</span>
            <span>${param.error}</span>
        </div>
        <script>setTimeout(() => document.getElementById('admin-flash-err')?.remove(), 5000);</script>
    </c:if>

    <!-- Barra Lateral Izquierda (Sidebar) -->
    <%@ include file="admin_sidebar.jsp" %>

    <!-- Contenedor Principal con Header Superior -->
    <div class="flex-1 flex flex-col min-w-0 md:pl-64">

        <!-- Top Header Superior -->
        <header class="h-16 bg-[#131313]/90 backdrop-blur-md border-b border-border-industrial sticky top-0 z-40 px-6 flex items-center justify-between">
            <div class="flex items-center gap-4">
                <!-- Mobile toggle -->
                <button class="md:hidden text-text-muted hover:text-primary-fixed p-1.5 rounded focus:outline-none" onclick="toggleAdminSidebar()">
                    <span class="material-symbols-outlined">menu</span>
                </button>
                <div class="flex items-center gap-2 font-mono text-xs text-text-muted">
                    <span class="text-primary-fixed uppercase tracking-wider font-semibold">Back-Office</span>
                    <span>/</span>
                    <span class="text-white capitalize">${not empty moduloActivo ? moduloActivo : 'Dashboard'}</span>
                </div>
            </div>

            <!-- Acciones Rápidas & Perfil -->
            <div class="flex items-center gap-4">
                <!-- Ver tienda pública -->
                <a href="${contextPath}/app?accion=home" target="_blank"
                   class="hidden sm:flex items-center gap-1.5 font-mono text-xs text-text-muted hover:text-primary-fixed px-3 py-1.5 rounded border border-border-industrial hover:border-primary-fixed transition-all"
                   title="Abrir tienda en nueva pestaña">
                    <span class="material-symbols-outlined text-[16px]">storefront</span>
                    <span>Ver Tienda</span>
                </a>

                <!-- Perfil Admin -->
                <div class="flex items-center gap-3 pl-3 border-l border-border-industrial">
                    <div class="w-8 h-8 rounded-full bg-primary-fixed/20 border border-primary-fixed text-primary-fixed flex items-center justify-center font-mono font-bold text-xs">
                        ${not empty sessionScope.usuarioActual ? sessionScope.usuarioActual.nombre.substring(0,1) : 'A'}
                    </div>
                    <div class="hidden lg:flex flex-col text-left">
                        <span class="text-xs font-semibold text-white leading-tight">
                            ${not empty sessionScope.usuarioActual ? sessionScope.usuarioActual.nombreCompleto : 'Super Admin'}
                        </span>
                        <span class="text-[10px] font-mono text-primary-fixed">ADMINISTRADOR</span>
                    </div>
                    <a href="${contextPath}/app?accion=logout"
                       class="text-text-muted hover:text-rogue-red transition-colors p-1.5 rounded hover:bg-surface-card"
                       title="Cerrar Sesión">
                        <span class="material-symbols-outlined text-[20px]">logout</span>
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content Area -->
        <main class="flex-1 p-6 lg:p-8 bg-[#0A0A0A] overflow-y-auto">
