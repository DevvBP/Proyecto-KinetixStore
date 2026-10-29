<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
     INCLUDE: footer.jsp
     Pie de página corporativo refinado con enlaces auditados y modales legales.
     Incluir con: <%@ include file="includes/footer.jsp" %>
     Cierra los tags <main>, <body> y <html> abiertos en header.jsp.
--%>

</main><!-- /main (abierto en header.jsp) -->

<!-- ====== FOOTER REFINADO ====== -->
<footer class="w-full py-14 px-margin-mobile md:px-margin-desktop bg-surface-container-lowest border-t border-border-industrial">
    <div class="grid grid-cols-1 md:grid-cols-3 gap-10 max-w-container-max mx-auto mb-12">

        <!-- Brand & Misión Column -->
        <div class="col-span-1 flex flex-col gap-4">
            <a class="font-headline-md text-headline-md text-primary-fixed flex items-center gap-2 hover:text-white transition-colors"
               href="${contextPath}/app?accion=home">
                <span class="material-symbols-outlined filled text-[26px]">fitness_center</span>
                KinexStore
            </a>
            <p class="font-body-md text-on-surface-variant text-sm leading-relaxed">
                Ingeniería biomécanica de alta resistencia, nutrición clínica certificada por INVIMA y tecnología de prescripción deportiva para atletas que demandan resultados sin compromisos.
            </p>
            <div class="flex items-center gap-2 text-xs font-mono text-primary-fixed/80">
                <span class="w-2 h-2 rounded-full bg-primary-fixed animate-pulse"></span>
                Distribuidor Autorizado &bull; Certificación ISO 9001
            </div>
        </div>

        <!-- Links: Categorías y Objetivos -->
        <div class="col-span-1">
            <h4 class="font-label-md text-primary mb-4 uppercase tracking-widest text-sm font-bold">Catálogos &amp; Objetivos</h4>
            <ul class="flex flex-col gap-2.5">
                <li>
                    <a class="font-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200 flex items-center gap-1.5"
                       href="${contextPath}/catalogo/equipamiento">
                        <span class="material-symbols-outlined text-xs">chevron_right</span> Maquinaria Pesada &amp; Poleas
                    </a>
                </li>
                <li>
                    <a class="font-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200 flex items-center gap-1.5"
                       href="${contextPath}/catalogo/suplementos">
                        <span class="material-symbols-outlined text-xs">chevron_right</span> Suplementación Grado Clínico
                    </a>
                </li>
                <li>
                    <a class="font-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200 flex items-center gap-1.5"
                       href="${contextPath}/catalogo/accesorios">
                        <span class="material-symbols-outlined text-xs">chevron_right</span> Accesorios &amp; Grip Pro
                    </a>
                </li>
                <li>
                    <a class="font-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200 flex items-center gap-1.5"
                       href="${contextPath}/planes/configurar">
                        <span class="material-symbols-outlined text-xs">chevron_right</span> Asistente de Planes Personalizados
                    </a>
                </li>
            </ul>
        </div>

        <!-- Links: Soporte y Respaldo Institucional -->
        <div class="col-span-1">
            <h4 class="font-label-md text-primary mb-4 uppercase tracking-widest text-sm font-bold">Garantía &amp; Respaldo</h4>
            <ul class="flex flex-col gap-2.5">
                <li>
                    <a class="font-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200 flex items-center gap-1.5"
                       href="${contextPath}/catalogo/equipamiento" id="footer-specs" title="Catálogo general con fichas técnicas y dimensiones">
                        <span class="material-symbols-outlined text-xs">description</span> Especificaciones Técnicas
                    </a>
                </li>
                <li>
                    <button type="button" onclick="abrirModalGarantia()"
                            class="font-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200 flex items-center gap-1.5 text-left"
                            id="footer-garantia">
                        <span class="material-symbols-outlined text-xs">verified</span> Garantía Oficial &amp; INVIMA
                    </button>
                </li>
                <li>
                    <a class="font-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200 flex items-center gap-1.5"
                       href="${contextPath}/planes/configurar" id="footer-especialistas" title="Conecta con el equipo de coaches de KinexStore">
                        <span class="material-symbols-outlined text-xs">groups</span> Red de Especialistas Kinex
                    </a>
                </li>
                <li>
                    <button type="button" onclick="abrirModalPrivacidad()"
                            class="font-label-sm text-text-muted hover:text-primary-fixed transition-colors duration-200 flex items-center gap-1.5 text-left"
                            id="footer-privacidad">
                        <span class="material-symbols-outlined text-xs">security</span> Políticas de Privacidad &amp; Datos
                    </button>
                </li>
            </ul>
        </div>
    </div>

    <!-- Copyright -->
    <div class="max-w-container-max mx-auto border-t border-border-industrial pt-6 flex flex-col sm:flex-row justify-between items-center gap-4 text-xs font-mono text-text-muted">
        <span>
            &copy; 2026 KinexStore Colombia. Todos los derechos reservados.
        </span>
        <div class="flex items-center gap-6">
            <span>Seguridad SSL 256-Bit</span>
            <span>Cifrado BCrypt Activo</span>
            <span class="text-primary-fixed font-bold">v2.1.0 Enterprise</span>
        </div>
    </div>
</footer>

<!-- ==============================================================
     MODAL 1: GARANTÍA OFICIAL Y REGISTRO INVIMA
     ============================================================== -->
<div id="modal-garantia" class="fixed inset-0 z-[300] bg-black/80 backdrop-blur-sm hidden flex items-center justify-center p-4">
    <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT max-w-lg w-full p-6 text-on-surface relative shadow-2xl">
        <button onclick="cerrarModalGarantia()" class="absolute top-4 right-4 text-on-surface-variant hover:text-white" aria-label="Cerrar">
            <span class="material-symbols-outlined">close</span>
        </button>
        <div class="flex items-center gap-3 mb-4 text-primary-fixed">
            <span class="material-symbols-outlined text-3xl">verified</span>
            <h3 class="font-headline-md text-lg text-primary">Garantía Oficial y Registro INVIMA</h3>
        </div>
        <div class="font-body-md text-sm text-on-surface-variant space-y-3 leading-relaxed">
            <p>
                <strong>Maquinaria y Estructuras:</strong> Toda nuestra línea pesada cuenta con <strong>5 años de garantía estructural</strong> en chasis de acero tubular y 1 año en componentes de desgaste (poleas de nylon, rodamientos sellados y guayas de aviación).
            </p>
            <p>
                <strong>Suplementación Clínica:</strong> El 100% de los suplementos comercializados por KinexStore poseen Registro Sanitario legal emitido por el Instituto Nacional de Vigilancia de Medicamentos y Alimentos (INVIMA).
            </p>
            <p>
                Cada lote es trazable con certificado analítico de pureza microbiológica y libre de metales pesados.
            </p>
        </div>
        <div class="mt-6 pt-4 border-t border-border-industrial flex justify-end">
            <button onclick="cerrarModalGarantia()" class="bg-primary-fixed text-black font-label-md px-5 py-2 rounded text-xs font-bold uppercase hover:bg-white transition-all">
                Entendido
            </button>
        </div>
    </div>
</div>

<!-- ==============================================================
     MODAL 2: POLÍTICAS DE PRIVACIDAD Y SEGURIDAD
     ============================================================== -->
<div id="modal-privacidad" class="fixed inset-0 z-[300] bg-black/80 backdrop-blur-sm hidden flex items-center justify-center p-4">
    <div class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT max-w-lg w-full p-6 text-on-surface relative shadow-2xl">
        <button onclick="cerrarModalPrivacidad()" class="absolute top-4 right-4 text-on-surface-variant hover:text-white" aria-label="Cerrar">
            <span class="material-symbols-outlined">close</span>
        </button>
        <div class="flex items-center gap-3 mb-4 text-primary-fixed">
            <span class="material-symbols-outlined text-3xl">lock</span>
            <h3 class="font-headline-md text-lg text-primary">Políticas de Privacidad y Protección de Datos</h3>
        </div>
        <div class="font-body-md text-sm text-on-surface-variant space-y-3 leading-relaxed">
            <p>
                En cumplimiento de la <strong>Ley Estatutaria 1581 de 2012</strong> de Protección de Datos Personales, KinexStore informa que la información capturada en los formularios de registro y generación de planes se utiliza exclusivamente para:
            </p>
            <ul class="list-disc pl-5 space-y-1 text-xs">
                <li>Personalización biométrica de planes de nutrición y rutinas físicas en PDF.</li>
                <li>Despacho logístico de compras y emisión de guías de transporte nacional.</li>
                <li>Autenticación segura: tus contraseñas están irreversiblemente cifradas con <strong>BCrypt (factor de coste 10)</strong>.</li>
            </ul>
            <p class="text-xs">
                KinexStore nunca comparte ni comercializa información de clientes con redes publicitarias de terceros.
            </p>
        </div>
        <div class="mt-6 pt-4 border-t border-border-industrial flex justify-end">
            <button onclick="cerrarModalPrivacidad()" class="bg-primary-fixed text-black font-label-md px-5 py-2 rounded text-xs font-bold uppercase hover:bg-white transition-all">
                Aceptar
            </button>
        </div>
    </div>
</div>

<!-- ====== SCRIPTS GLOBALES ====== -->
<script src="${contextPath}/assets/js/app.js"></script>

<script>
    function toggleMobileNav() {
        const menu = document.getElementById('mobile-nav-menu');
        if (menu) menu.classList.toggle('hidden');
    }

    function abrirModalGarantia() {
        const modal = document.getElementById('modal-garantia');
        if (modal) modal.classList.remove('hidden');
    }

    function cerrarModalGarantia() {
        const modal = document.getElementById('modal-garantia');
        if (modal) modal.classList.add('hidden');
    }

    function abrirModalPrivacidad() {
        const modal = document.getElementById('modal-privacidad');
        if (modal) modal.classList.remove('hidden');
    }

    function cerrarModalPrivacidad() {
        const modal = document.getElementById('modal-privacidad');
        if (modal) modal.classList.add('hidden');
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
