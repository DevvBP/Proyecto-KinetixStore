/**
 * KinexStore — Client-Side JavaScript
 * Maneja interacciones de interfaz, formato de moneda COP,
 * carrusel de video en Hero, y recálculo de costos de envío.
 */

// ==================== FORMATEO DE MONEDA COP ====================
function formatCOP(amount) {
    return new Intl.NumberFormat('es-CO', {
        style: 'currency',
        currency: 'COP',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    }).format(amount) + ' COP';
}

// ==================== MOBILE NAVIGATION ====================
function toggleMobileNav() {
    const menu = document.getElementById('mobile-nav-menu');
    if (menu) {
        menu.classList.toggle('hidden');
    }
}

// ==================== HERO: VIDEO DE FONDO CON TRANSICIÓN ====================
(function initHeroVideoBackground() {
    const stage = document.getElementById('hero-bg-stage');
    if (!stage) return;

    const baseVideoPath = stage.getAttribute('data-context-path') || '';
    const clips = [
        baseVideoPath + '/assets/video/hero-1.mp4',
        baseVideoPath + '/assets/video/hero-2.mp4',
        baseVideoPath + '/assets/video/hero-3.mp4'
    ];

    const videos = stage.querySelectorAll('.hero-bg-video');
    if (!videos || videos.length < 2) return;

    let current = 0;   // índice del video visible
    let next = 1;      // índice del video receptor
    let clipIndex = 0; // índice del clip

    const supportsVideo = !!document.createElement('video').canPlayType;
    if (!supportsVideo) return;

    // Inicializar primer clip
    videos[current].src = clips[clipIndex];
    videos[current].play().catch(() => {});

    function playNextClip() {
        clipIndex = (clipIndex + 1) % clips.length;
        const nextVideoEl = videos[next];
        const currentVideoEl = videos[current];

        nextVideoEl.src = clips[clipIndex];
        nextVideoEl.currentTime = 0;
        const playPromise = nextVideoEl.play();
        if (playPromise) playPromise.catch(() => {});

        nextVideoEl.classList.add('active');
        currentVideoEl.classList.remove('active');

        current = next;
        next = current === 0 ? 1 : 0;
    }

    videos.forEach((video) => {
        video.addEventListener('timeupdate', () => {
            if (!video.classList.contains('active')) return;
            if (video.duration && video.currentTime >= video.duration - 1.4) {
                if (video.dataset.transitioning === 'true') return;
                video.dataset.transitioning = 'true';
                playNextClip();
                setTimeout(() => { video.dataset.transitioning = 'false'; }, 2000);
            }
        });
    });
})();

// ==================== RECÁLCULO DINÁMICO DE ENVÍO EN CARRITO ====================
function updateShippingTotal() {
    const shippingSelect = document.getElementById('shipping-select');
    const subtotalEl = document.getElementById('cart-subtotal-val');
    const totalEl = document.getElementById('cart-total-val');
    const shippingDisplayEl = document.getElementById('cart-shipping-val');

    if (!shippingSelect || !subtotalEl || !totalEl) return;

    const subtotal = parseFloat(subtotalEl.getAttribute('data-subtotal')) || 0;
    const shippingCost = parseFloat(shippingSelect.value) || 0;
    const grandTotal = subtotal + shippingCost;

    if (shippingDisplayEl) {
        shippingDisplayEl.textContent = formatCOP(shippingCost);
    }
    totalEl.textContent = formatCOP(grandTotal);
}

// Escuchar cambios en selector de envío
document.addEventListener('DOMContentLoaded', () => {
    const shippingSelect = document.getElementById('shipping-select');
    if (shippingSelect) {
        shippingSelect.addEventListener('change', updateShippingTotal);
    }

    // Auto-dismiss de alertas flash
    const flashMsg = document.getElementById('flash-msg');
    if (flashMsg) {
        setTimeout(() => {
            flashMsg.style.transition = 'opacity 0.5s ease';
            flashMsg.style.opacity = '0';
            setTimeout(() => flashMsg.remove(), 500);
        }, 3500);
    }
});
