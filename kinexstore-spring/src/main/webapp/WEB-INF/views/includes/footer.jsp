<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
     INCLUDE: footer.jsp
     Pie de página reutilizable con newsletter, links y copyright.
     Incluir con: <%@ include file="includes/footer.jsp" %>
     Cierra los tags <main>, <body> y <html> abiertos en header.jsp.
--%>

</main><!-- /main (abierto en header.jsp) -->

<!-- ====== FOOTER ====== -->
<footer class="w-full py-12 px-margin-mobile md:px-margin-desktop bg-surface-container-lowest border-t border-border-industrial">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter max-w-container-max mx-auto mb-12">

        <!-- Brand Column -->
        <div class="col-span-1 md:col-span-1 flex flex-col gap-4">
            <a class="font-headline-md text-headline-md text-primary-fixed flex items-center gap-2 hover:text-white transition-colors"
               href="${contextPath}/app?accion=home">
                <span class="material-symbols-outlined filled text-[24px]">fitness_center</span>
                KinexStore
            </a>
            <p class="font-body-md text-body-md text-on-surface-variant text-sm">
                Herramientas de precisión para el atleta moderno.
            </p>
        </div>

        <!-- Links: Objetivos -->
        <div class="col-span-1">
            <h4 class="font-label-md text-label-md text-primary mb-4 uppercase tracking-widest">Objetivos</h4>
            <ul class="flex flex-col gap-2">
                <li><a class="font-label-sm text-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200"
                       href="${contextPath}/app?accion=listarEquipamiento&cat=racks">Fuerza &amp; Peso Libre</a></li>
                <li><a class="font-label-sm text-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200"
                       href="${contextPath}/app?accion=listarEquipamiento">Cardio Inteligente</a></li>
                <li><a class="font-label-sm text-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200"
                       href="${contextPath}/app?accion=listarSuplementos&cat=aminoacidos">Recuperación</a></li>
                <li><a class="font-label-sm text-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200"
                       href="${contextPath}/app?accion=configurarPlan">Planes Personalizados</a></li>
            </ul>
        </div>

        <!-- Links: Soporte -->
        <div class="col-span-1">
            <h4 class="font-label-md text-label-md text-primary mb-4 uppercase tracking-widest">Soporte</h4>
            <ul class="flex flex-col gap-2">
                <li><a class="font-label-sm text-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200"
                       href="#" id="footer-specs">Especificaciones Técnicas</a></li>
                <li><a class="font-label-sm text-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200"
                       href="#" id="footer-garantia">Garantía Oficial</a></li>
                <li><a class="font-label-sm text-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200"
                       href="#" id="footer-especialistas">Red de Especialistas</a></li>
                <li><a class="font-label-sm text-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200"
                       href="#" id="footer-privacidad">Políticas de Privacidad</a></li>
            </ul>
        </div>

        <!-- Newsletter Subscription -->
        <div class="col-span-1">
            <h4 class="font-label-md text-label-md text-primary mb-4 uppercase tracking-widest">Correo Electrónico</h4>
            <form action="${contextPath}/app" method="post"
                  class="flex gap-0 border border-border-industrial rounded-sm overflow-hidden focus-within:border-primary-fixed transition-colors"
                  id="newsletter-form">
                <input type="hidden" name="accion" value="suscribir">
                <input class="bg-surface-charcoal border-none font-label-sm text-primary focus:ring-0 w-full px-3 py-2 placeholder:text-text-muted"
                       placeholder="Correo electrónico"
                       type="email"
                       name="email"
                       id="newsletter-email"
                       required
                       aria-label="Tu correo electrónico">
                <button class="bg-border-industrial hover:bg-primary-fixed hover:text-black transition-colors px-3 flex items-center justify-center text-primary"
                        type="submit" id="newsletter-btn" aria-label="Suscribirse">
                    <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                </button>
            </form>
            <c:if test="${not empty param.error and param.error == 'newsletter_invalid'}">
                <p class="text-error text-xs mt-1 font-label-sm">Email no válido. Intenta de nuevo.</p>
            </c:if>
        </div>
    </div>

    <!-- Copyright -->
    <div class="max-w-container-max mx-auto border-t border-border-industrial pt-6 flex flex-col md:flex-row justify-between items-center gap-4">
        <span class="font-label-sm text-label-sm text-text-muted">
            © 2026 KinexStore. Herramientas de precisión para el atleta moderno.
        </span>
        <div class="flex gap-4">
            <a class="text-text-muted hover:text-primary-fixed transition-colors" href="#" aria-label="Idioma">
                <span class="material-symbols-outlined text-[20px]">language</span>
            </a>
        </div>
    </div>
</footer>

<!-- ====== SCRIPTS GLOBALES ====== -->
<script src="${contextPath}/assets/js/app.js"></script>

<!-- Scroll effect en navbar -->
<script>
    function toggleMobileNav() {
        const menu = document.getElementById('mobile-nav-menu');
        if (menu) menu.classList.toggle('hidden');
    }

    window.addEventListener('scroll', () => {
        const nav = document.getElementById('main-nav');
        if (!nav) return;
        if (window.scrollY > 20) {
            nav.classList.add('shadow-lg');
            nav.classList.replace('bg-surface-charcoal/80', 'bg-[#0A0A0A]/95');
        } else {
            nav.classList.remove('shadow-lg');
            nav.classList.replace('bg-[#0A0A0A]/95', 'bg-surface-charcoal/80');
        }
    });
</script>

</body>
</html>
