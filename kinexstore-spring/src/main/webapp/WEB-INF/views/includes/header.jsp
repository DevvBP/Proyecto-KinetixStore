<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- ================================================================
     INCLUDE: header.jsp
     Barra de navegación principal reutilizable.
     Incluir con: <%@ include file="includes/header.jsp" %>
     Variables esperadas en request/session:
       - vistaActiva (String): "home" | "equipamiento" | "suplementos" | "training"
       - usuarioActual (session, User): usuario autenticado o null
     ================================================================ --%>
<!DOCTYPE html>
<html class="dark" lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${not empty pageTitle}">${pageTitle} — KinexStore</c:when>
            <c:otherwise>KinexStore - Elite Performance</c:otherwise>
        </c:choose>
    </title>
    <meta name="description" content="${not empty pageDescription ? pageDescription : 'E-commerce especializado en maquinaria de gimnasio, suplementación de élite y planes de entrenamiento personalizados.'}">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">

    <!-- Tailwind CSS CDN (mismo del proyecto original) -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "surface-variant": "#353534",
                        "secondary": "#ffb59e",
                        "on-tertiary": "#21323e",
                        "on-tertiary-container": "#556774",
                        "error": "#ffb4ab",
                        "primary-fixed": "#c3f400",
                        "surface-bright": "#3a3939",
                        "surface-container-lowest": "#0e0e0e",
                        "text-muted": "#A1A1A1",
                        "on-primary-fixed": "#161e00",
                        "surface-dim": "#131313",
                        "tertiary": "#ffffff",
                        "on-secondary": "#5e1700",
                        "on-primary": "#283500",
                        "outline": "#8e9379",
                        "on-secondary-container": "#521300",
                        "surface-tint": "#abd600",
                        "background": "#131313",
                        "inverse-on-surface": "#313030",
                        "on-surface": "#e5e2e1",
                        "on-error": "#690005",
                        "surface": "#131313",
                        "surface-container": "#201f1f",
                        "secondary-container": "#ff571a",
                        "on-surface-variant": "#c4c9ac",
                        "outline-variant": "#444933",
                        "surface-container-low": "#1c1b1b",
                        "border-industrial": "#333333",
                        "on-background": "#e5e2e1",
                        "error-container": "#93000a",
                        "rogue-red": "#D11919",
                        "surface-container-high": "#2a2a2a",
                        "surface-container-highest": "#353534",
                        "primary": "#ffffff",
                        "primary-container": "#c3f400",
                        "inverse-primary": "#506600",
                        "primary-fixed-dim": "#abd600",
                        "inverse-surface": "#e5e2e1",
                        "surface-charcoal": "#1A1A1A"
                    },
                    "borderRadius": {
                        "DEFAULT": "0.125rem",
                        "lg": "0.25rem",
                        "xl": "0.5rem",
                        "full": "0.75rem"
                    },
                    "fontFamily": {
                        "display-lg": ["IBM Plex Sans"],
                        "headline-lg-mobile": ["IBM Plex Sans"],
                        "body-md": ["Inter"],
                        "label-md": ["JetBrains Mono"],
                        "headline-lg": ["IBM Plex Sans"],
                        "label-sm": ["JetBrains Mono"],
                        "body-lg": ["Inter"],
                        "headline-md": ["IBM Plex Sans"]
                    },
                    "fontSize": {
                        "display-lg": ["64px", {"lineHeight": "72px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                        "headline-lg-mobile": ["32px", {"lineHeight": "38px", "fontWeight": "700"}],
                        "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                        "label-md": ["14px", {"lineHeight": "20px", "letterSpacing": "0.05em", "fontWeight": "500"}],
                        "headline-lg": ["40px", {"lineHeight": "48px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                        "label-sm": ["12px", {"lineHeight": "16px", "letterSpacing": "0.08em", "fontWeight": "500"}],
                        "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                        "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}]
                    },
                    "spacing": {
                        "unit": "4px",
                        "margin-mobile": "16px",
                        "container-max": "1440px",
                        "gutter": "24px",
                        "margin-desktop": "64px"
                    }
                }
            }
        }
    </script>

    <!-- Estilos propios de KinexStore -->
    <link rel="stylesheet" href="${contextPath}/assets/css/styles.css">
</head>
<body class="bg-[#0A0A0A] text-on-surface antialiased min-h-screen flex flex-col font-body-md overflow-x-hidden selection:bg-primary-fixed selection:text-black">

<!-- Mensajes flash (feedback de acciones) -->
<c:if test="${not empty param.msg}">
    <div id="flash-msg" class="fixed top-20 left-1/2 -translate-x-1/2 z-[200] bg-primary-fixed text-black font-label-md px-6 py-3 rounded shadow-lg shadow-primary-fixed/30 animate-bounce">
        <c:choose>
            <c:when test="${param.msg == 'producto_agregado'}">✓ Producto agregado al carrito</c:when>
            <c:when test="${param.msg == 'bienvenido'}">Bienvenido a KinexStore</c:when>
            <c:when test="${param.msg == 'registro_exitoso'}">✓ Cuenta creada exitosamente</c:when>
            <c:when test="${param.msg == 'sesion_cerrada'}">Sesión cerrada correctamente</c:when>
            <c:when test="${param.msg == 'newsletter_ok'}">✓ Suscripción confirmada</c:when>
            <c:otherwise>${param.msg}</c:otherwise>
        </c:choose>
    </div>
    <script>setTimeout(() => document.getElementById('flash-msg')?.remove(), 3000);</script>
</c:if>

<!-- Errores flash -->
<c:if test="${not empty param.error}">
    <div id="flash-error" class="fixed top-20 left-1/2 -translate-x-1/2 z-[200] bg-error-container text-on-error-container font-label-md px-6 py-3 rounded shadow-lg">
        <c:choose>
            <c:when test="${param.error == 'carrito_vacio'}">El carrito está vacío.</c:when>
            <c:when test="${param.error == 'producto_no_encontrado'}">Producto no encontrado.</c:when>
            <c:otherwise>${param.error}</c:otherwise>
        </c:choose>
    </div>
    <script>setTimeout(() => document.getElementById('flash-error')?.remove(), 4000);</script>
</c:if>

<!-- ====== TOP NAVIGATION BAR ====== -->
<header class="fixed top-0 w-full z-50 bg-surface-charcoal/80 backdrop-blur-md border-b border-border-industrial transition-all duration-300" id="main-nav">
    <div class="flex justify-between items-center px-margin-mobile md:px-margin-desktop py-4 max-w-container-max mx-auto">

        <!-- Brand Logo -->
        <a class="font-headline-md text-headline-md font-bold tracking-tighter text-primary-fixed flex items-center gap-2 hover:text-white transition-colors"
           href="${contextPath}/app?accion=home">
            <span class="material-symbols-outlined filled text-primary-fixed text-[28px]">fitness_center</span>
            KinexStore
        </a>

        <!-- Navigation Links (Desktop) -->
        <nav class="hidden md:flex items-center gap-8" aria-label="Navegación principal">
            <a class="font-label-md text-label-md transition-colors py-2 cursor-pointer hover:font-semibold
                      ${vistaActiva == 'equipamiento' ? 'text-primary-fixed' : 'text-on-surface-variant hover:text-primary-fixed'}"
               href="${contextPath}/app?accion=listarEquipamiento" id="nav-equipamiento">
                Equipamiento
            </a>
            <a class="font-label-md text-label-md transition-colors py-2 cursor-pointer hover:font-semibold
                      ${vistaActiva == 'suplementos' ? 'text-primary-fixed' : 'text-on-surface-variant hover:text-primary-fixed'}"
               href="${contextPath}/app?accion=listarSuplementos" id="nav-suplementacion">
                Suplementación
            </a>
            <a class="font-label-md text-label-md transition-colors py-2 cursor-pointer hover:font-semibold
                      ${vistaActiva == 'training' ? 'text-primary-fixed' : 'text-on-surface-variant hover:text-primary-fixed'}"
               href="${contextPath}/app?accion=configurarPlan" id="nav-planes">
                Planes
            </a>
        </nav>

        <!-- Trailing Actions -->
        <div class="flex items-center gap-4">
            <!-- Carrito -->
            <a href="${contextPath}/app?accion=verCarrito"
               class="text-on-surface hover:text-primary-fixed transition-colors p-2 rounded-lg hover:bg-surface-container-highest/50 hover:scale-110 duration-150 group relative"
               id="nav-carrito" aria-label="Ver carrito">
                <span class="material-symbols-outlined">shopping_cart</span>
                <c:if test="${not empty totalItemsCarrito and totalItemsCarrito > 0}">
                    <span class="absolute top-0 right-0 w-5 h-5 bg-primary-fixed rounded-full text-black text-[10px] font-bold flex items-center justify-center badge-pulse">
                        ${totalItemsCarrito}
                    </span>
                </c:if>
            </a>

            <!-- Perfil / Autenticación -->
            <c:choose>
                <c:when test="${not empty sessionScope.usuarioActual}">
                    <div class="flex items-center gap-2">
                        <span class="font-label-sm text-primary-fixed hidden md:inline">
                            ${sessionScope.usuarioActual.nombre}
                        </span>
                        <a href="${contextPath}/app?accion=logout"
                           class="text-on-surface hover:text-primary-fixed transition-colors p-2 rounded-lg hover:bg-surface-container-highest/50 duration-150"
                           title="Cerrar sesión">
                            <span class="material-symbols-outlined">logout</span>
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${contextPath}/app?accion=login"
                       class="text-on-surface hover:text-primary-fixed transition-colors p-2 rounded-lg hover:bg-surface-container-highest/50 hover:scale-110 duration-150"
                       id="nav-login" title="Iniciar sesión">
                        <span class="material-symbols-outlined">account_circle</span>
                    </a>
                </c:otherwise>
            </c:choose>

            <!-- Hamburger Mobile -->
            <button class="md:hidden text-on-surface p-2" id="mobile-menu-btn"
                    onclick="toggleMobileNav()" aria-label="Abrir menú móvil">
                <span class="material-symbols-outlined">menu</span>
            </button>
        </div>
    </div>

    <!-- Mobile Navigation Drawer -->
    <div class="md:hidden hidden border-t border-border-industrial bg-[#0A0A0A] px-6 py-4 space-y-3" id="mobile-nav-menu">
        <a class="block font-label-md text-on-surface hover:text-primary-fixed py-2"
           href="${contextPath}/app?accion=listarEquipamiento">Equipamiento</a>
        <a class="block font-label-md text-on-surface hover:text-primary-fixed py-2"
           href="${contextPath}/app?accion=listarSuplementos">Suplementación</a>
        <a class="block font-label-md text-on-surface hover:text-primary-fixed py-2"
           href="${contextPath}/app?accion=configurarPlan">Planes</a>
        <a class="block font-label-md text-on-surface hover:text-primary-fixed py-2"
           href="${contextPath}/app?accion=verCarrito">Mi Carrito</a>
    </div>
</header>

<main class="flex-grow pt-[73px]">
