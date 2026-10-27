<%@ page contentType="text/html; charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Error" />
<%@ include file="includes/header.jsp" %>

    <div class="flex flex-col items-center justify-center min-h-[60vh] px-margin-mobile text-center">
        <span class="material-symbols-outlined text-8xl text-border-industrial mb-6">error</span>

        <h1 class="font-headline-lg text-primary mb-4">
            <c:choose>
                <c:when test="${not empty errorCodigo}">Error ${errorCodigo}</c:when>
                <c:when test="${pageContext.errorData.statusCode == 404}">404 — Página no encontrada</c:when>
                <c:when test="${pageContext.errorData.statusCode == 403}">403 — Acceso denegado</c:when>
                <c:when test="${pageContext.errorData.statusCode == 500}">500 — Error interno del servidor</c:when>
                <c:otherwise>Algo salió mal</c:otherwise>
            </c:choose>
        </h1>

        <p class="font-body-lg text-on-surface-variant mb-8 max-w-md">
            <c:choose>
                <c:when test="${not empty errorMensaje}">${errorMensaje}</c:when>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    La página que buscas no existe o fue movida.
                </c:when>
                <c:when test="${pageContext.errorData.statusCode == 403}">
                    No tienes permisos para acceder a esta sección.
                </c:when>
                <c:otherwise>
                    Ocurrió un error inesperado. Por favor intenta de nuevo.
                </c:otherwise>
            </c:choose>
        </p>

        <div class="flex flex-wrap gap-4 justify-center">
            <a href="${contextPath}/app?accion=home"
               class="bg-primary-fixed text-black font-label-md px-8 py-4 rounded-DEFAULT
                      hover:bg-white transition-all duration-200 uppercase"
               id="error-btn-home">
                Ir al Inicio
            </a>
            <button onclick="history.back()"
                    class="bg-transparent border border-border-industrial text-on-surface font-label-md px-8 py-4 rounded-DEFAULT
                           hover:border-primary-fixed hover:text-primary-fixed transition-colors uppercase"
                    id="error-btn-back">
                Volver
            </button>
        </div>
    </div>

<%@ include file="includes/footer.jsp" %>
