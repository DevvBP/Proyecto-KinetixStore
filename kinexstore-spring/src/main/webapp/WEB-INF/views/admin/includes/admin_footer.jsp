<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%-- ================================================================
     ADMIN INCLUDE: admin_footer.jsp
     Cierre del layout principal administrativo y scripts auxiliares.
     ================================================================ --%>
        </main><!-- /main -->
    </div><!-- /flex-1 contenedor principal -->

    <!-- Scripts Globales de Back-Office (Modales y Helpers) -->
    <script>
        function openModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }
        }

        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }
        }

        // Cerrar modales al presionar tecla ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                document.querySelectorAll('.admin-modal:not(.hidden)').forEach(m => {
                    m.classList.add('hidden');
                    m.classList.remove('flex');
                });
            }
        });
    </script>
</body>
</html>
