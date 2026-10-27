package co.kinexstore.controllers;

import co.kinexstore.dtos.UsuarioRegistroDTO;
import co.kinexstore.enums.EstadoOrden;
import co.kinexstore.enums.LugarEntrenamiento;
import co.kinexstore.enums.NivelExperiencia;
import co.kinexstore.enums.ObjetivoPrincipal;
import co.kinexstore.enums.Rol;
import co.kinexstore.enums.TipoDieta;
import co.kinexstore.models.CartItem;
import co.kinexstore.models.Order;
import co.kinexstore.models.Product;
import co.kinexstore.models.TrainingPlan;
import co.kinexstore.models.User;
import co.kinexstore.models.UserFitnessProfile;
import co.kinexstore.repositories.OrderRepository;
import co.kinexstore.repositories.UserFitnessProfileRepository;
import co.kinexstore.repositories.UserRepository;
import co.kinexstore.services.CartService;
import co.kinexstore.services.CatalogService;
import co.kinexstore.services.PlanService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class EcommerceController {

    private final CatalogService catalogService;
    private final CartService cartService;
    private final PlanService planService;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;
    private final UserFitnessProfileRepository fitnessProfileRepository;

    // ----------------------------------------------------------------
    // 1. FRONT CONTROLLER DISPATCHER (/ & /app)
    // ----------------------------------------------------------------
    @GetMapping({"/", "/app", "/home"})
    public String handleGet(@RequestParam(value = "accion", required = false, defaultValue = "home") String accion,
                            @RequestParam(value = "cat", required = false) List<String> categorias,
                            @RequestParam(value = "q", required = false) String busqueda,
                            Model model, HttpSession session) {

        switch (accion.toLowerCase()) {
            case "listarequipamiento":
                return listarEquipamiento(categorias, model);

            case "listarsuplementos":
                return listarSuplementos(categorias, model);

            case "vercarrito":
                return verCarrito(model, session);

            case "checkout":
                return verCheckout(model, session);

            case "configurarplan":
                return mostrarFormularioPlan(model, session);

            case "login":
                return loginView();

            case "registro":
                return registroView(model, null);

            case "logout":
                session.invalidate();
                return "redirect:/app?msg=sesion_cerrada";

            case "home":
            default:
                if (busqueda != null && !busqueda.trim().isEmpty()) {
                    model.addAttribute("productos", catalogService.buscar(busqueda));
                    model.addAttribute("terminoBusqueda", busqueda);
                } else {
                    model.addAttribute("productos", catalogService.obtenerTodos());
                }
                model.addAttribute("vistaActiva", "home");
                return "home";
        }
    }

    // ----------------------------------------------------------------
    // 2. CATÁLOGO ESPECÍFICO
    // ----------------------------------------------------------------
    @GetMapping("/catalogo/equipamiento")
    public String listarEquipamiento(@RequestParam(value = "cat", required = false) List<String> categorias, Model model) {
        List<Product> productos = catalogService.obtenerEquipamiento(categorias);
        model.addAttribute("productos", productos);
        model.addAttribute("categoriasDisponibles", catalogService.getCategoriasEquipamiento());
        model.addAttribute("categoriasSeleccionadas", categorias != null ? categorias : new ArrayList<>());
        model.addAttribute("vistaActiva", "equipamiento");
        return "machinery";
    }

    @GetMapping("/catalogo/suplementos")
    public String listarSuplementos(@RequestParam(value = "cat", required = false) List<String> categorias, Model model) {
        List<Product> productos = catalogService.obtenerSuplementos(categorias);
        model.addAttribute("productos", productos);
        model.addAttribute("categoriasDisponibles", catalogService.getCategoriasSuplementos());
        model.addAttribute("categoriasSeleccionadas", categorias != null ? categorias : new ArrayList<>());
        model.addAttribute("vistaActiva", "suplementos");
        return "supplements";
    }

    // ----------------------------------------------------------------
    // 3. DETALLE DE PRODUCTO + CROSS-SELLING (P4)
    // ----------------------------------------------------------------
    @GetMapping("/producto/{id}")
    public String verDetalleProducto(@PathVariable Long id, Model model) {
        Product producto = catalogService.obtenerProductoPorId(id);
        List<Product> crossSelling = catalogService.getCrossSelling(producto);

        model.addAttribute("producto", producto);
        model.addAttribute("crossSelling", crossSelling);
        model.addAttribute("vistaActiva", producto.getTipo().name().toLowerCase());
        return "producto_detalle";
    }

    // ----------------------------------------------------------------
    // 4. AGREGAR AL CARRITO (AJAX/POST sin cambio de página)
    // ----------------------------------------------------------------
    /**
     * Endpoint dedicado para agregar al carrito desde las tarjetas de catálogo.
     * Redirige de vuelta a la página que lo llamó usando el header Referer,
     * con un parámetro de confirmación visual sin cambiar de sección.
     */
    @PostMapping("/carrito/agregar")
    public String agregarAlCarrito(@RequestParam("productoId") Long productoId,
                                   @RequestParam(value = "cantidad", defaultValue = "1") int cantidad,
                                   @RequestParam(value = "origen", defaultValue = "/") String origen,
                                   HttpSession session) {
        Product producto = catalogService.obtenerProductoPorId(productoId);
        cartService.agregar(session, producto, cantidad);
        // Redirige de vuelta a la misma página del catálogo (no al carrito)
        return "redirect:" + origen + (origen.contains("?") ? "&" : "?") + "msg=agregado&pid=" + productoId;
    }

    // ----------------------------------------------------------------
    // 5. CARRITO DE COMPRAS Y CHECKOUT PROTEGIDO
    // ----------------------------------------------------------------
    @GetMapping("/carrito")
    public String verCarrito(Model model, HttpSession session) {
        List<CartItem> items = cartService.getCarrito(session);
        model.addAttribute("items", items);
        model.addAttribute("itemsCarrito", items);
        model.addAttribute("subtotal", cartService.calcularSubtotal(session));
        model.addAttribute("pesoTotal", cartService.getPesoTotal(session));
        model.addAttribute("envioSugerido", cartService.sugerirModalidadEnvio(session));
        model.addAttribute("modalidadSugerida", cartService.sugerirModalidadEnvio(session));
        model.addAttribute("totalCOP", cartService.calcularTotal(session, "local"));
        model.addAttribute("vistaActiva", "carrito");
        return "cart";
    }

    @GetMapping("/checkout")
    public String verCheckout(Model model, HttpSession session) {
        User usuarioActual = (User) session.getAttribute("usuarioActual");
        if (usuarioActual == null) {
            session.setAttribute("redirectUrlPostAuth", "/checkout");
            return "redirect:/registro?from=checkout";
        }

        List<CartItem> items = cartService.getCarrito(session);
        if (items.isEmpty()) {
            return "redirect:/carrito?msg=carrito_vacio";
        }

        double subtotal = cartService.calcularSubtotal(session);
        double pesoTotal = cartService.getPesoTotal(session);
        String envioSugerido = cartService.sugerirModalidadEnvio(session);
        double costoEnvio = cartService.calcularEnvio(envioSugerido);
        double total = subtotal + costoEnvio;

        model.addAttribute("usuario", usuarioActual);
        model.addAttribute("itemsCarrito", items);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("pesoTotal", pesoTotal);
        model.addAttribute("envioSugerido", envioSugerido);
        model.addAttribute("costoEnvio", costoEnvio);
        model.addAttribute("total", total);
        model.addAttribute("vistaActiva", "checkout");
        return "checkout";
    }

    @PostMapping("/checkout")
    public String procesarCheckout(@RequestParam(value = "modalidadEnvio", defaultValue = "estandar") String modalidad,
                                   HttpSession session, Model model) {
        User usuarioActual = (User) session.getAttribute("usuarioActual");
        if (usuarioActual == null) {
            session.setAttribute("redirectUrlPostAuth", "/checkout");
            return "redirect:/registro?from=checkout";
        }

        List<CartItem> items = cartService.getCarrito(session);
        if (items.isEmpty()) {
            return "redirect:/carrito";
        }

        double subtotal = cartService.calcularSubtotal(session);
        double pesoTotal = cartService.getPesoTotal(session);
        double costoEnvio = cartService.calcularEnvio(modalidad);
        double total = subtotal + costoEnvio;
        boolean esPesada = pesoTotal > 50;

        String transportadora = esPesada ? "Kinex Heavy Freight" : "Coordinadora Mercantil";
        String numOrden = "ORD-" + System.currentTimeMillis() % 1000000;

        Order orden = Order.builder()
                .numeroOrden(numOrden)
                .clienteNombre(usuarioActual.getNombreCompleto())
                .clienteEmail(usuarioActual.getEmail())
                .clienteTelefono(usuarioActual.getTelefono())
                .direccionEnvio(usuarioActual.getDireccionDetallada() != null ? usuarioActual.getDireccionDetallada() : usuarioActual.getDireccion())
                .ciudad(usuarioActual.getCiudad())
                .estado(EstadoOrden.PENDIENTE)
                .subtotal(subtotal)
                .costoEnvio(costoEnvio)
                .descuentoMayorista(0.0)
                .total(total)
                .esCargaPesada(esPesada)
                .transportadora(transportadora)
                .numeroGuia("GUIA-PEND-" + System.currentTimeMillis() % 100000)
                .notasLogistica("Pedido generado desde checkout web. Modalidad de flete: " + modalidad.toUpperCase())
                .build();

        orderRepository.save(orden);
        cartService.vaciar(session);

        return "redirect:/app?msg=orden_creada&ordenId=" + orden.getNumeroOrden();
    }

    // ----------------------------------------------------------------
    // 6. PLANES DE ENTRENAMIENTO — WIZARD + AUTH GATE (P2 & P3)
    // ----------------------------------------------------------------
    @GetMapping("/planes")
    public String mostrarFormularioPlan(Model model, HttpSession session) {
        model.addAttribute("vistaActiva", "training");
        // Si hay datos del wizard guardados en sesión (pre-auth), los rescatamos
        if (session.getAttribute("wizardData") != null) {
            model.addAttribute("wizardData", session.getAttribute("wizardData"));
        }
        return "training";
    }

    @GetMapping("/planes/configurar")
    public String mostrarFormularioPlanLegacy(Model model) {
        model.addAttribute("vistaActiva", "training");
        return "training";
    }

    /**
     * AUTH GATE: Si el usuario no está logueado, guarda los datos del wizard en
     * sesión y lo redirige al registro. Al registrarse, se retoma el flujo.
     */
    @PostMapping("/planes/generar")
    public String generarPlan(@RequestParam("nivel") String nivelStr,
                              @RequestParam("dias") int dias,
                              @RequestParam("objetivo") String objetivoStr,
                              @RequestParam(value = "edad", defaultValue = "25") int edad,
                              @RequestParam(value = "pesoKg", defaultValue = "70") double pesoKg,
                              @RequestParam(value = "estaturaCm", defaultValue = "170") double estaturaCm,
                              @RequestParam(value = "lugarEntrenamiento", defaultValue = "GYM_COMERCIAL") String lugarStr,
                              @RequestParam(value = "tipoDieta", defaultValue = "OMNIVORO") String dietaStr,
                              @RequestParam(value = "nombre", required = false) String nombre,
                              @RequestParam(value = "email", required = false) String email,
                              Model model, HttpSession session) {

        NivelExperiencia nivel = NivelExperiencia.valueOf(nivelStr.toUpperCase());
        ObjetivoPrincipal objetivo = ObjetivoPrincipal.valueOf(objetivoStr.toUpperCase());
        LugarEntrenamiento lugar = LugarEntrenamiento.valueOf(lugarStr.toUpperCase());
        TipoDieta dieta = TipoDieta.valueOf(dietaStr.toUpperCase());

        User usuarioActual = (User) session.getAttribute("usuarioActual");

        // --- AUTH GATE ---
        if (usuarioActual == null) {
            // Guardar datos del wizard en sesión temporalmente
            session.setAttribute("wizardNivel", nivelStr);
            session.setAttribute("wizardDias", dias);
            session.setAttribute("wizardObjetivo", objetivoStr);
            session.setAttribute("wizardEdad", edad);
            session.setAttribute("wizardPesoKg", pesoKg);
            session.setAttribute("wizardEstaturaCm", estaturaCm);
            session.setAttribute("wizardLugar", lugarStr);
            session.setAttribute("wizardDieta", dietaStr);
            session.setAttribute("wizardNombre", nombre);
            session.setAttribute("wizardEmail", email);
            // Redirigir al registro con intención de plan
            session.setAttribute("redirectUrlPostAuth", "/planes/generar-post-auth");
            return "redirect:/registro?from=planes";
        }

        // --- GENERAR PLAN ---
        String nombreAtleta = usuarioActual.getNombreCompleto();
        String emailAtleta = usuarioActual.getEmail();

        // Guardar/actualizar perfil de atleta
        guardarPerfilAtleta(usuarioActual, nivel, objetivo, edad, pesoKg, estaturaCm, dias, lugar, dieta);

        TrainingPlan plan = planService.crearPlan(nivel, dias, objetivo, nombreAtleta, emailAtleta);
        List<Product> suplementosReales = catalogService.getSuplementosRealesPorObjetivo(objetivo);

        model.addAttribute("plan", plan);
        model.addAttribute("planGenerado", plan);
        model.addAttribute("suplementosRecomendados", planService.getSuplementosRecomendados(objetivo));
        model.addAttribute("suplementosReales", suplementosReales);
        model.addAttribute("vistaActiva", "training");
        return "plan_resultado";
    }

    /**
     * Endpoint POST-AUTH: retoma el flujo del wizard después del registro.
     * Los datos del wizard se leen desde la sesión y se genera el plan.
     */
    @GetMapping("/planes/generar-post-auth")
    public String generarPlanPostAuth(Model model, HttpSession session) {
        User usuarioActual = (User) session.getAttribute("usuarioActual");
        if (usuarioActual == null) {
            return "redirect:/planes";
        }

        // Recuperar datos del wizard de la sesión
        String nivelStr   = session.getAttribute("wizardNivel") != null ? (String) session.getAttribute("wizardNivel") : "PRINCIPIANTE";
        int dias           = session.getAttribute("wizardDias") != null ? (int) session.getAttribute("wizardDias") : 4;
        String objetivoStr = session.getAttribute("wizardObjetivo") != null ? (String) session.getAttribute("wizardObjetivo") : "HIPERTROFIA";
        int edad           = session.getAttribute("wizardEdad") != null ? (int) session.getAttribute("wizardEdad") : 25;
        double pesoKg     = session.getAttribute("wizardPesoKg") != null ? (double) session.getAttribute("wizardPesoKg") : 70.0;
        double estaturaCm = session.getAttribute("wizardEstaturaCm") != null ? (double) session.getAttribute("wizardEstaturaCm") : 170.0;
        String lugarStr   = session.getAttribute("wizardLugar") != null ? (String) session.getAttribute("wizardLugar") : "GYM_COMERCIAL";
        String dietaStr   = session.getAttribute("wizardDieta") != null ? (String) session.getAttribute("wizardDieta") : "OMNIVORO";

        NivelExperiencia nivel = NivelExperiencia.valueOf(nivelStr.toUpperCase());
        ObjetivoPrincipal objetivo = ObjetivoPrincipal.valueOf(objetivoStr.toUpperCase());
        LugarEntrenamiento lugar = LugarEntrenamiento.valueOf(lugarStr.toUpperCase());
        TipoDieta dieta = TipoDieta.valueOf(dietaStr.toUpperCase());

        guardarPerfilAtleta(usuarioActual, nivel, objetivo, edad, pesoKg, estaturaCm, dias, lugar, dieta);

        // Limpiar datos del wizard de la sesión
        limpiarWizardDeSesion(session);

        TrainingPlan plan = planService.crearPlan(nivel, dias, objetivo,
                usuarioActual.getNombreCompleto(), usuarioActual.getEmail());
        List<Product> suplementosReales = catalogService.getSuplementosRealesPorObjetivo(objetivo);

        model.addAttribute("plan", plan);
        model.addAttribute("planGenerado", plan);
        model.addAttribute("suplementosRecomendados", planService.getSuplementosRecomendados(objetivo));
        model.addAttribute("suplementosReales", suplementosReales);
        model.addAttribute("vistaActiva", "training");
        return "plan_resultado";
    }

    // ----------------------------------------------------------------
    // 7. REGISTRO Y AUTENTICACIÓN CON FUSIÓN DE CARRITO
    // ----------------------------------------------------------------
    @GetMapping("/login")
    public String loginView() {
        return "login";
    }

    @GetMapping("/registro")
    public String registroView(Model model, @RequestParam(value = "from", required = false) String from) {
        if (!model.containsAttribute("dto")) {
            model.addAttribute("dto", new UsuarioRegistroDTO());
        }
        if (from != null) {
            model.addAttribute("fromContext", from);
        }
        return "registro";
    }

    @PostMapping("/registro")
    public String procesarRegistro(@Valid @ModelAttribute("dto") UsuarioRegistroDTO dto,
                                   BindingResult bindingResult,
                                   HttpSession session,
                                   Model model) {
        if (bindingResult.hasErrors()) {
            List<String> errores = bindingResult.getAllErrors().stream()
                    .map(e -> e.getDefaultMessage())
                    .toList();
            model.addAttribute("erroresValidacion", errores);
            model.addAttribute("dto", dto);
            return "registro";
        }

        if (userRepository.existsByEmail(dto.getEmail().trim().toLowerCase())) {
            model.addAttribute("errorRegistro", "El correo electrónico ya se encuentra registrado. Inicia sesión con tus credenciales.");
            model.addAttribute("dto", dto);
            return "registro";
        }

        User nuevo = User.builder()
                .nombre(dto.getNombre().trim())
                .apellido(dto.getApellido().trim())
                .email(dto.getEmail().trim().toLowerCase())
                .passwordHash(dto.getPassword())
                .telefono(dto.getTelefono().trim())
                .pais(dto.getPais())
                .estadoProvincia(dto.getEstadoProvincia().trim())
                .ciudad(dto.getCiudad().trim())
                .codigoPostal(dto.getCodigoPostal().trim())
                .direccionDetallada(dto.getDireccionDetallada().trim())
                .direccion(dto.getDireccionDetallada().trim() + ", " + dto.getCiudad().trim() + ", " + dto.getEstadoProvincia().trim() + ", " + dto.getPais())
                .rol(Rol.CLIENTE)
                .activo(true)
                .build();

        userRepository.save(nuevo);
        session.setAttribute("usuarioActual", nuevo);

        String redirect = (String) session.getAttribute("redirectUrlPostAuth");
        if (redirect != null && !redirect.isBlank()) {
            session.removeAttribute("redirectUrlPostAuth");
            return "redirect:" + redirect;
        }

        return "redirect:/app?msg=registro_exitoso";
    }

    // ----------------------------------------------------------------
    // 8. DISPATCHER DE FORMULARIOS POST LEGACY (/app)
    // ----------------------------------------------------------------
    @PostMapping("/app")
    public String handlePost(@RequestParam("accion") String accion,
                             @RequestParam(value = "productoId", required = false) Long productoId,
                             @RequestParam(value = "cantidad", defaultValue = "1") int cantidad,
                             @RequestParam(value = "modalidadEnvio", defaultValue = "estandar") String modalidadEnvio,
                             @RequestParam(value = "nivel", required = false) String nivelStr,
                             @RequestParam(value = "dias", defaultValue = "3") int dias,
                             @RequestParam(value = "objetivo", required = false) String objetivoStr,
                             @RequestParam(value = "nombre", required = false) String nombre,
                             @RequestParam(value = "apellido", required = false) String apellido,
                             @RequestParam(value = "email", required = false) String email,
                             @RequestParam(value = "password", required = false) String password,
                             @RequestParam(value = "telefono", required = false) String telefono,
                             @RequestParam(value = "direccion", required = false) String direccion,
                             @RequestParam(value = "ciudad", required = false) String ciudad,
                             @RequestParam(value = "estadoProvincia", required = false) String estadoProvincia,
                             @RequestParam(value = "pais", required = false) String pais,
                             @RequestParam(value = "codigoPostal", required = false) String codigoPostal,
                             @RequestParam(value = "direccionDetallada", required = false) String direccionDetallada,
                             @RequestParam(value = "origen", required = false) String origen,
                             HttpSession session, Model model) {

        switch (accion.toLowerCase()) {
            case "agregarcarrito":
                if (productoId != null) {
                    Product producto = catalogService.obtenerProductoPorId(productoId);
                    cartService.agregar(session, producto, cantidad);
                }
                // Si hay origen (referer), volver a él; si no, al carrito
                if (origen != null && !origen.isBlank()) {
                    return "redirect:" + origen + (origen.contains("?") ? "&" : "?") + "msg=agregado&pid=" + productoId;
                }
                return "redirect:/carrito?msg=producto_agregado";

            case "actualizarcarrito":
                if (productoId != null) {
                    cartService.actualizarCantidad(session, productoId, cantidad);
                }
                return "redirect:/carrito";

            case "eliminarcarrito":
                if (productoId != null) {
                    cartService.eliminar(session, productoId);
                }
                return "redirect:/carrito";

            case "vaciarcarrito":
                cartService.vaciar(session);
                return "redirect:/carrito";

            case "checkout":
                return verCheckout(model, session);

            case "generarplan":
                return "redirect:/planes/generar";

            case "login":
                Optional<User> userOpt = userRepository.findByEmail(email != null ? email.trim().toLowerCase() : "");
                if (userOpt.isPresent() && userOpt.get().getPasswordHash().equals(password)) {
                    session.setAttribute("usuarioActual", userOpt.get());

                    String redirect = (String) session.getAttribute("redirectUrlPostAuth");
                    if (redirect != null && !redirect.isBlank()) {
                        session.removeAttribute("redirectUrlPostAuth");
                        return "redirect:" + redirect;
                    }

                    if (userOpt.get().esAdmin()) {
                        return "redirect:/admin";
                    }
                    return "redirect:/app?msg=bienvenido";
                }
                model.addAttribute("errorLogin", "Credenciales incorrectas. Verifica tu correo y contraseña.");
                return "login";

            case "registro":
                UsuarioRegistroDTO dto = UsuarioRegistroDTO.builder()
                        .nombre(nombre != null ? nombre : "")
                        .apellido(apellido != null ? apellido : "")
                        .email(email != null ? email : "")
                        .password(password != null ? password : "")
                        .telefono(telefono != null ? telefono : "+57 300 000 0000")
                        .pais(pais != null ? pais : "Colombia")
                        .estadoProvincia(estadoProvincia != null ? estadoProvincia : "Antioquia")
                        .ciudad(ciudad != null ? ciudad : "Medellín")
                        .codigoPostal(codigoPostal != null ? codigoPostal : "050021")
                        .direccionDetallada(direccionDetallada != null ? direccionDetallada : (direccion != null ? direccion : "Dirección estándar"))
                        .build();
                return procesarRegistro(dto, new org.springframework.validation.BeanPropertyBindingResult(dto, "dto"), session, model);

            default:
                return "redirect:/app";
        }
    }

    // ----------------------------------------------------------------
    // HELPERS PRIVADOS
    // ----------------------------------------------------------------

    /** Crea o actualiza el UserFitnessProfile del usuario autenticado. */
    private void guardarPerfilAtleta(User usuario, NivelExperiencia nivel, ObjetivoPrincipal objetivo,
                                     int edad, double pesoKg, double estaturaCm,
                                     int dias, LugarEntrenamiento lugar, TipoDieta dieta) {
        try {
            UserFitnessProfile perfil = fitnessProfileRepository
                    .findByUserId(usuario.getId())
                    .orElse(UserFitnessProfile.builder().user(usuario).build());

            perfil.setNivelExperiencia(nivel);
            perfil.setObjetivo(objetivo);
            perfil.setEdad(edad);
            perfil.setPesoKg(pesoKg);
            perfil.setEstaturaCm(estaturaCm);
            perfil.setDiasDisponibles(dias);
            perfil.setLugarEntrenamiento(lugar);
            perfil.setTipoDieta(dieta);

            fitnessProfileRepository.save(perfil);
        } catch (Exception e) {
            // Log error pero no bloquear la generación del plan
        }
    }

    /** Limpia los atributos del wizard de la sesión HTTP. */
    private void limpiarWizardDeSesion(HttpSession session) {
        String[] wizardKeys = {"wizardNivel", "wizardDias", "wizardObjetivo", "wizardEdad",
                               "wizardPesoKg", "wizardEstaturaCm", "wizardLugar", "wizardDieta",
                               "wizardNombre", "wizardEmail"};
        for (String key : wizardKeys) {
            session.removeAttribute(key);
        }
    }

}

