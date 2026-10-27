<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Iniciar Sesión" />
<%@ include file="includes/header.jsp" %>

    <div class="max-w-md mx-auto px-margin-mobile py-24" id="section-login">
        <div class="text-center mb-8">
            <span class="material-symbols-outlined text-4xl text-primary-fixed mb-3 block">account_circle</span>
            <h1 class="font-headline-lg text-primary mb-2">Bienvenido de nuevo</h1>
            <p class="font-body-md text-on-surface-variant">Ingresa a tu cuenta KinexStore</p>
        </div>

        <c:if test="${not empty errorLogin}">
            <div class="mb-4 p-3 bg-error-container border border-error rounded text-on-error-container font-label-md text-sm" role="alert">
                ${errorLogin}
            </div>
        </c:if>

        <c:if test="${param.origen == 'protegido'}">
            <div class="mb-4 p-3 bg-surface-container border border-border-industrial rounded text-on-surface-variant font-label-md text-sm" role="alert">
                <span class="material-symbols-outlined text-[16px] align-middle">lock</span>
                Necesitas iniciar sesión para continuar.
            </div>
        </c:if>

        <form action="${contextPath}/app" method="post" id="login-form"
              class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-8 space-y-6">
            <input type="hidden" name="accion" value="login">

            <div>
                <label for="login-email" class="font-label-md text-on-surface-variant block mb-2">
                    Correo Electrónico
                </label>
                <input type="email" name="email" id="login-email"
                       class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3
                              focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all focus-glow"
                       placeholder="tu@correo.com" required autocomplete="email">
            </div>

            <div>
                <label for="login-password" class="font-label-md text-on-surface-variant block mb-2">
                    Contraseña
                </label>
                <input type="password" name="password" id="login-password"
                       class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3
                              focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all focus-glow"
                       placeholder="••••••••" required autocomplete="current-password">
            </div>

            <button type="submit"
                    class="w-full bg-primary-fixed text-black font-label-md px-8 py-4 rounded-DEFAULT
                           hover:bg-white hover:shadow-lg hover:shadow-primary-fixed/50
                           transition-all duration-200 uppercase font-bold tracking-wider"
                    id="btn-login">
                Iniciar Sesión
            </button>

            <p class="text-center font-label-sm text-on-surface-variant">
                ¿No tienes cuenta?
                <a href="${contextPath}/app?accion=registro"
                   class="text-primary-fixed hover:underline" id="link-registro">Regístrate gratis</a>
            </p>
        </form>
    </div>

<%@ include file="includes/footer.jsp" %>
