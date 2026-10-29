package co.kinexstore.controllers;

import co.kinexstore.enums.TipoProducto;
import co.kinexstore.models.Product;
import co.kinexstore.services.CatalogService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/v1/productos")
@RequiredArgsConstructor
@Tag(name = "Productos", description = "Endpoints RESTful de consulta y filtrado del catálogo oficial de KinexStore")
public class ProductRestController {

    private final CatalogService catalogService;

    @Operation(
        summary = "Listar catálogo completo de productos",
        description = "Retorna la colección de productos con filtros opcionales por tipo (EQUIPAMIENTO, SUPLEMENTO, ACCESORIO) o término de búsqueda."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Lista de productos obtenida exitosamente"),
        @ApiResponse(responseCode = "500", description = "Error interno del servidor")
    })
    @GetMapping
    public ResponseEntity<List<Product>> listarProductos(
            @Parameter(description = "Tipo de producto a filtrar (EQUIPAMIENTO, SUPLEMENTO, ACCESORIO)")
            @RequestParam(value = "tipo", required = false) TipoProducto tipo,
            @Parameter(description = "Término de búsqueda en nombre, descripción o categoría")
            @RequestParam(value = "q", required = false) String busqueda) {

        log.info("API GET /api/v1/productos - Filtros: tipo={}, q={}", tipo, busqueda);

        if (busqueda != null && !busqueda.trim().isEmpty()) {
            return ResponseEntity.ok(catalogService.buscar(busqueda));
        }

        if (tipo != null) {
            return switch (tipo) {
                case EQUIPAMIENTO -> ResponseEntity.ok(catalogService.obtenerEquipamiento(null));
                case SUPLEMENTO   -> ResponseEntity.ok(catalogService.obtenerSuplementos(null));
                case ACCESORIO    -> ResponseEntity.ok(catalogService.obtenerAccesorios(null));
            };
        }

        return ResponseEntity.ok(catalogService.obtenerTodos());
    }

    @Operation(
        summary = "Obtener producto por ID",
        description = "Retorna el detalle técnico completo de un producto específico, incluyendo peso dual y especificaciones."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Producto encontrado"),
        @ApiResponse(responseCode = "400", description = "ID de producto inválido o no encontrado")
    })
    @GetMapping("/{id}")
    public ResponseEntity<Product> obtenerPorId(
            @Parameter(description = "Identificador único del producto en base de datos")
            @PathVariable("id") Long id) {
        log.info("API GET /api/v1/productos/{}", id);
        Product producto = catalogService.obtenerProductoPorId(id);
        return ResponseEntity.ok(producto);
    }
}

