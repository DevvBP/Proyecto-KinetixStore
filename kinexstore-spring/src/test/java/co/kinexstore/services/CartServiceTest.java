package co.kinexstore.services;

import co.kinexstore.enums.TipoProducto;
import co.kinexstore.models.CartItem;
import co.kinexstore.models.Product;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Unidad 10: Pruebas Unitarias de CartService")
class CartServiceTest {

    @InjectMocks
    private CartService cartService;

    @Mock
    private HttpSession session;

    private List<CartItem> carritoMemoria;
    private Product rackPesado;
    private Product creatina;

    @BeforeEach
    void setUp() {
        carritoMemoria = new ArrayList<>();
        lenient().when(session.getAttribute("carrito")).thenReturn(carritoMemoria);

        rackPesado = Product.builder()
                .id(1L)
                .nombre("Power Rack Profesional")
                .precio(4800000)
                .pesoKg(180.0)
                .tipo(TipoProducto.EQUIPAMIENTO)
                .stock(5)
                .disponible(true)
                .build();

        creatina = Product.builder()
                .id(2L)
                .nombre("Creatina Monohidratada 500g")
                .precio(140000)
                .pesoKg(0.5)
                .tipo(TipoProducto.SUPLEMENTO)
                .stock(30)
                .disponible(true)
                .build();
    }

    @Test
    @DisplayName("Debe agregar un producto nuevo al carrito exitosamente")
    void testAgregarProductoNuevoAlCarrito() {
        cartService.agregar(session, creatina, 2);

        assertEquals(1, carritoMemoria.size());
        assertEquals(2, carritoMemoria.get(0).getCantidad());
        assertEquals("Creatina Monohidratada 500g", carritoMemoria.get(0).getProduct().getNombre());
    }

    @Test
    @DisplayName("Debe acumular la cantidad si el producto ya existe en el carrito")
    void testAgregarProductoExistenteIncrementaCantidad() {
        cartService.agregar(session, creatina, 1);
        cartService.agregar(session, creatina, 3);

        assertEquals(1, carritoMemoria.size());
        assertEquals(4, carritoMemoria.get(0).getCantidad());
        assertEquals(4, cartService.getTotalItems(session));
    }

    @Test
    @DisplayName("Debe calcular subtotal y total con diferentes modalidades de envío dinámico")
    void testCalcularSubtotalYTotalConEnvio() {
        cartService.agregar(session, creatina, 2); // 2 x 140.000 = 280.000 COP, peso = 1.0 kg (<= 5 kg)

        double subtotal = cartService.calcularSubtotal(session);
        assertEquals(280000.0, subtotal, 0.01);

        // Envío local: $ 0 COP
        double totalLocal = cartService.calcularTotal(session, "local");
        assertEquals(280000.0, totalLocal, 0.01);

        // Envío estándar base <= 5 kg: $ 15.000 COP -> Total: 295.000 COP
        double totalEstandar = cartService.calcularTotal(session, "estandar");
        assertEquals(295000.0, totalEstandar, 0.01);

        // Envío express base <= 5 kg: $ 25.000 COP -> Total: 305.000 COP
        double totalExpress = cartService.calcularTotal(session, "express");
        assertEquals(305000.0, totalExpress, 0.01);
    }

    @Test
    @DisplayName("Debe calcular recargo por kilogramo extra o fracción algorítmicamente")
    void testCalculadoraDinamicaAlgoritmicaPorPeso() {
        // Caso 1: 5.0 kg exactos -> Tarifa base exacta ($ 15.000)
        double envio5Kg = cartService.calcularEnvio(5.0, "estandar");
        assertEquals(15000.0, envio5Kg, 0.01);

        // Caso 2: 7.2 kg -> 5 kg base ($ 15.000) + ceil(2.2) = 3 kg extra * $ 2.000 ($ 6.000) = $ 21.000
        double envio7Kg = cartService.calcularEnvio(7.2, "estandar");
        assertEquals(21000.0, envio7Kg, 0.01);

        // Caso 3: Express con 8.0 kg -> 5 kg base ($ 25.000) + 3 kg extra * $ 3.500 ($ 10.500) = $ 35.500
        double express8Kg = cartService.calcularEnvio(8.0, "express");
        assertEquals(35500.0, express8Kg, 0.01);

        // Caso 4: Carga industrial pesada con 180 kg -> 50 kg base ($ 80.000) + 130 kg extra * $ 1.500 ($ 195.000) = $ 275.000
        double pesado180Kg = cartService.calcularEnvio(180.0, "pesado");
        assertEquals(275000.0, pesado180Kg, 0.01);

        // Caso 5: Explicación de flete no nula y descriptiva
        String explicacion = cartService.getExplicacionFlete(7.2, "estandar");
        assertNotNull(explicacion);
        assertTrue(explicacion.contains("2.000"));
    }

    @Test
    @DisplayName("Debe convertir y calcular pesos duales en kilogramos y libras con precisión")
    void testCalculoConversionLibrasDual() {
        cartService.agregar(session, rackPesado, 1); // 180 kg

        double pesoKg = cartService.getPesoTotal(session);
        assertEquals(180.0, pesoKg, 0.01);

        CartItem item = carritoMemoria.get(0);
        double pesoLbsEsperado = 180.0 * 2.20462;
        assertEquals(pesoLbsEsperado, item.getPesoTotalLbs(), 0.01);

        assertTrue(item.getPesoTotalDual().contains("180.0 kg"));
        assertTrue(item.getPesoTotalDual().contains("396.83 lbs"));
    }

    @Test
    @DisplayName("Debe sugerir envío industrial pesado si supera 50 kg, estándar si supera 10 kg, o local si es ligero")
    void testSugerirModalidadEnvioPorPesoPesado() {
        cartService.agregar(session, rackPesado, 1); // 180 kg > 50 kg
        String sugerencia = cartService.sugerirModalidadEnvio(session);
        assertEquals("pesado", sugerencia);

        carritoMemoria.clear();
        cartService.agregar(session, creatina, 30); // 30 x 0.5 kg = 15 kg (> 10 kg)
        String sugerenciaEstandar = cartService.sugerirModalidadEnvio(session);
        assertEquals("estandar", sugerenciaEstandar);

        carritoMemoria.clear();
        cartService.agregar(session, creatina, 1); // 0.5 kg (<= 10 kg)
        String sugerenciaLocal = cartService.sugerirModalidadEnvio(session);
        assertEquals("local", sugerenciaLocal);
    }

    @Test
    @DisplayName("Debe actualizar cantidad o eliminar el producto cuando la cantidad es cero o menor")
    void testActualizarCantidadYEliminarItem() {
        cartService.agregar(session, creatina, 2);
        cartService.actualizarCantidad(session, 2L, 5);
        assertEquals(5, carritoMemoria.get(0).getCantidad());

        cartService.actualizarCantidad(session, 2L, 0);
        assertTrue(carritoMemoria.isEmpty());
    }
}
