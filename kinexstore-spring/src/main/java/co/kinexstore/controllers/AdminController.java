package co.kinexstore.controllers;

import co.kinexstore.enums.*;
import co.kinexstore.models.*;
import co.kinexstore.services.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Map;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    // ----------------------------------------------------------------
    // 1. GET DISPATCHER (/admin & /admin?accion=XXX)
    // ----------------------------------------------------------------
    @GetMapping({"", "/"})
    public String handleGet(@RequestParam(value = "accion", required = false, defaultValue = "dashboard") String accion,
                            @RequestParam(value = "filtroEstado", required = false) String filtroEstado,
                            @RequestParam(value = "q", required = false) String busqueda,
                            Model model) {

        switch (accion) {
            case "gestionarMaquinas":
                model.addAttribute("maquinas", adminService.listarMaquinaria());
                model.addAttribute("moduloActivo", "maquinas");
                return "admin/maquinas";

            case "gestionarSuplementos":
                model.addAttribute("suplementos", adminService.listarSuplementos());
                model.addAttribute("moduloActivo", "suplementos");
                return "admin/suplementos";

            case "gestionarPedidos":
                EstadoOrden estadoFiltro = null;
                if (filtroEstado != null && !filtroEstado.isBlank()) {
                    try {
                        estadoFiltro = EstadoOrden.valueOf(filtroEstado.toUpperCase());
                    } catch (IllegalArgumentException ignored) {}
                }
                model.addAttribute("pedidos", adminService.listarPedidos(estadoFiltro));
                model.addAttribute("filtroActual", filtroEstado);
                model.addAttribute("moduloActivo", "pedidos");
                return "admin/pedidos";

            case "gestionarPlanes":
                model.addAttribute("planes", adminService.listarPlanes(null));
                model.addAttribute("moduloActivo", "planes");
                return "admin/planes";

            case "gestionarUsuarios":
                model.addAttribute("usuarios", adminService.listarUsuarios(busqueda));
                model.addAttribute("busqueda", busqueda);
                model.addAttribute("moduloActivo", "usuarios");
                return "admin/usuarios";

            case "gestionarPromos":
                model.addAttribute("promociones", adminService.listarPromociones());
                model.addAttribute("moduloActivo", "promos");
                return "admin/promos";

            case "dashboard":
            default:
                Map<String, Object> metricas = adminService.getMetricasDashboard();
                model.addAttribute("metricas", metricas);
                model.addAttribute("moduloActivo", "dashboard");
                return "admin/dashboard";
        }
    }

    // ----------------------------------------------------------------
    // 2. RUTAS RESTFUL ALTERNATIVAS
    // ----------------------------------------------------------------
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        return handleGet("dashboard", null, null, model);
    }

    @GetMapping("/maquinas")
    public String maquinas(Model model) {
        return handleGet("gestionarMaquinas", null, null, model);
    }

    @GetMapping("/suplementos")
    public String suplementos(Model model) {
        return handleGet("gestionarSuplementos", null, null, model);
    }

    @GetMapping("/pedidos")
    public String pedidos(@RequestParam(value = "filtroEstado", required = false) String filtroEstado, Model model) {
        return handleGet("gestionarPedidos", filtroEstado, null, model);
    }

    @GetMapping("/planes")
    public String planes(Model model) {
        return handleGet("gestionarPlanes", null, null, model);
    }

    @GetMapping("/usuarios")
    public String usuarios(@RequestParam(value = "q", required = false) String busqueda, Model model) {
        return handleGet("gestionarUsuarios", null, busqueda, model);
    }

    @GetMapping("/promos")
    public String promos(Model model) {
        return handleGet("gestionarPromos", null, null, model);
    }

    // ----------------------------------------------------------------
    // 3. POST DISPATCHER (/admin)
    // ----------------------------------------------------------------
    @PostMapping({"", "/"})
    public String handlePost(@RequestParam("accion") String accion,
                             @RequestParam(value = "id", required = false) Long id,
                             @RequestParam(value = "nombre", required = false) String nombre,
                             @RequestParam(value = "descripcion", required = false) String descripcion,
                             @RequestParam(value = "precio", defaultValue = "0") double precio,
                             @RequestParam(value = "pesoKg", defaultValue = "0") double pesoKg,
                             @RequestParam(value = "categoria", required = false) String categoria,
                             @RequestParam(value = "dimensiones", required = false) String dimensiones,
                             @RequestParam(value = "stock", defaultValue = "50") int stock,
                             @RequestParam(value = "descuentoMayoristaPct", defaultValue = "0") double descuentoMayoristaPct,
                             @RequestParam(value = "imagenPath", required = false) String imagenPath,
                             @RequestParam(value = "numeroLote", required = false) String numeroLote,
                             @RequestParam(value = "fechaVencimiento", required = false) String fechaVencimientoStr,
                             @RequestParam(value = "registroInvima", required = false) String registroInvima,
                             @RequestParam(value = "estado", required = false) String estadoStr,
                             @RequestParam(value = "guia", required = false) String guia,
                             @RequestParam(value = "transportadora", required = false) String transportadora,
                             @RequestParam(value = "notas", required = false) String notas,
                             @RequestParam(value = "entrenador", required = false) String entrenador,
                             @RequestParam(value = "rutina", required = false) String rutina,
                             @RequestParam(value = "dieta", required = false) String dieta,
                             @RequestParam(value = "pdfNombre", required = false) String pdfNombre,
                             @RequestParam(value = "rol", required = false) String rolStr,
                             @RequestParam(value = "codigo", required = false) String codigo,
                             @RequestParam(value = "titulo", required = false) String titulo,
                             @RequestParam(value = "subtitulo", required = false) String subtitulo,
                             @RequestParam(value = "porcentajeDescuento", defaultValue = "0") double porcentajeDescuento,
                             @RequestParam(value = "descuentoFijoCOP", defaultValue = "0") double descuentoFijoCOP,
                             @RequestParam(value = "compraMinimaCOP", defaultValue = "0") double compraMinimaCOP,
                             @RequestParam(value = "fechaInicio", required = false) String fechaInicioStr,
                             @RequestParam(value = "fechaFin", required = false) String fechaFinStr,
                             @RequestParam(value = "usosRestantes", defaultValue = "100") int usosRestantes,
                             @RequestParam(value = "ctaTexto", required = false) String ctaTexto,
                             @RequestParam(value = "ctaUrl", required = false) String ctaUrl,
                             @RequestParam(value = "tipo", required = false) String tipoPromoStr) {

        switch (accion) {
            case "guardarMaquina":
                Product maquina = Product.builder()
                        .id(id != null && id > 0 ? id : null)
                        .nombre(nombre)
                        .descripcion(descripcion)
                        .precio(precio)
                        .pesoKg(pesoKg)
                        .categoria(categoria)
                        .dimensiones(dimensiones != null ? dimensiones : "N/A")
                        .stock(stock)
                        .descuentoMayoristaPct(descuentoMayoristaPct)
                        .imagenPath(imagenPath != null && !imagenPath.isBlank() ? imagenPath : "assets/img/bento-pesada.jpg")
                        .tipo(TipoProducto.EQUIPAMIENTO)
                        .disponible(true)
                        .build();
                adminService.guardarProducto(maquina);
                return "redirect:/admin?accion=gestionarMaquinas&msg=maquina_guardada";

            case "eliminarMaquina":
                if (id != null) adminService.eliminarProducto(id);
                return "redirect:/admin?accion=gestionarMaquinas&msg=maquina_eliminada";

            case "guardarSuplemento":
                LocalDate fechaVenc = null;
                if (fechaVencimientoStr != null && !fechaVencimientoStr.isBlank()) {
                    try { fechaVenc = LocalDate.parse(fechaVencimientoStr); } catch (Exception ignored) {}
                }
                Product suplemento = Product.builder()
                        .id(id != null && id > 0 ? id : null)
                        .nombre(nombre)
                        .descripcion(descripcion)
                        .precio(precio)
                        .pesoKg(pesoKg)
                        .categoria(categoria)
                        .stock(stock)
                        .numeroLote(numeroLote != null ? numeroLote : "LOT-GEN")
                        .fechaVencimiento(fechaVenc)
                        .registroInvima(registroInvima != null ? registroInvima : "RSA-PENDIENTE")
                        .imagenPath(imagenPath != null && !imagenPath.isBlank() ? imagenPath : "assets/img/bento-suplementacion.jpg")
                        .tipo(TipoProducto.SUPLEMENTO)
                        .disponible(true)
                        .build();
                adminService.guardarProducto(suplemento);
                return "redirect:/admin?accion=gestionarSuplementos&msg=suplemento_guardado";

            case "eliminarSuplemento":
                if (id != null) adminService.eliminarProducto(id);
                return "redirect:/admin?accion=gestionarSuplementos&msg=suplemento_eliminado";

            case "actualizarPedido":
                if (id != null && estadoStr != null) {
                    EstadoOrden nuevoEstado = EstadoOrden.valueOf(estadoStr.toUpperCase());
                    adminService.actualizarEstadoPedido(id, nuevoEstado, guia, transportadora, notas);
                }
                return "redirect:/admin?accion=gestionarPedidos&msg=pedido_actualizado";

            case "asignarPlan":
                if (id != null) {
                    EstadoPlan estadoPlan = null;
                    if (estadoStr != null) {
                        try { estadoPlan = EstadoPlan.valueOf(estadoStr.toUpperCase()); } catch (Exception ignored) {}
                    }
                    adminService.actualizarEntregaPlan(id, entrenador, rutina, dieta, pdfNombre, estadoPlan);
                }
                return "redirect:/admin?accion=gestionarPlanes&msg=plan_actualizado";

            case "cambiarRolUsuario":
                if (id != null && rolStr != null) {
                    Rol nuevoRol = Rol.valueOf(rolStr.toUpperCase());
                    adminService.cambiarRolUsuario(id, nuevoRol);
                }
                return "redirect:/admin?accion=gestionarUsuarios&msg=rol_actualizado";

            case "toggleEstadoUsuario":
                if (id != null) adminService.toggleEstadoUsuario(id);
                return "redirect:/admin?accion=gestionarUsuarios&msg=estado_usuario_actualizado";

            case "guardarPromo":
                LocalDate fInicio = null;
                LocalDate fFin = null;
                if (fechaInicioStr != null && !fechaInicioStr.isBlank()) {
                    try { fInicio = LocalDate.parse(fechaInicioStr); } catch (Exception ignored) {}
                }
                if (fechaFinStr != null && !fechaFinStr.isBlank()) {
                    try { fFin = LocalDate.parse(fechaFinStr); } catch (Exception ignored) {}
                }
                TipoPromo tipoPromo = TipoPromo.CUPON;
                if (tipoPromoStr != null) {
                    try { tipoPromo = TipoPromo.valueOf(tipoPromoStr.toUpperCase()); } catch (Exception ignored) {}
                }
                Promotion promo = Promotion.builder()
                        .id(id != null && id > 0 ? id : null)
                        .codigo(codigo)
                        .titulo(titulo)
                        .subtitulo(subtitulo)
                        .porcentajeDescuento(porcentajeDescuento)
                        .descuentoFijoCOP(descuentoFijoCOP)
                        .compraMinimaCOP(compraMinimaCOP)
                        .fechaInicio(fInicio)
                        .fechaFin(fFin)
                        .usosRestantes(usosRestantes)
                        .ctaTexto(ctaTexto != null ? ctaTexto : "Explorar Oferta")
                        .ctaUrl(ctaUrl != null ? ctaUrl : "/catalogo/equipamiento")
                        .tipo(tipoPromo)
                        .activa(true)
                        .build();
                adminService.guardarPromocion(promo);
                return "redirect:/admin?accion=gestionarPromos&msg=promo_guardada";

            case "togglePromo":
                if (id != null) adminService.togglePromocion(id);
                return "redirect:/admin?accion=gestionarPromos&msg=promo_actualizada";

            case "eliminarPromo":
                if (id != null) adminService.eliminarPromocion(id);
                return "redirect:/admin?accion=gestionarPromos&msg=promo_eliminada";

            default:
                return "redirect:/admin?accion=dashboard";
        }
    }
}
