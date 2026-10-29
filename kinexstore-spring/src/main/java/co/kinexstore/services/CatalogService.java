package co.kinexstore.services;

import co.kinexstore.enums.ObjetivoPrincipal;
import co.kinexstore.enums.TipoProducto;
import co.kinexstore.models.Product;
import co.kinexstore.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CatalogService {

    private final ProductRepository productRepository;

    /** Mapa de objetivos a categorías de suplementos relacionadas */
    private static final Map<ObjetivoPrincipal, List<String>> SUPL_CATEGORIAS_POR_OBJETIVO = Map.of(
        ObjetivoPrincipal.HIPERTROFIA,   List.of("proteinas", "creatinas"),
        ObjetivoPrincipal.FUERZA_MAXIMA, List.of("creatinas", "preentrenos"),
        ObjetivoPrincipal.PERDIDA_GRASA, List.of("proteinas", "aminoacidos", "salud"),
        ObjetivoPrincipal.RESISTENCIA,   List.of("aminoacidos", "preentrenos", "salud")
    );

    public List<Product> obtenerEquipamiento(List<String> categoriasFiltro) {
        if (categoriasFiltro != null && !categoriasFiltro.isEmpty()) {
            return productRepository.findByTipo(TipoProducto.EQUIPAMIENTO).stream()
                    .filter(p -> categoriasFiltro.contains(p.getCategoria()))
                    .toList();
        }
        return productRepository.findByTipo(TipoProducto.EQUIPAMIENTO);
    }

    public List<Product> obtenerSuplementos(List<String> categoriasFiltro) {
        if (categoriasFiltro != null && !categoriasFiltro.isEmpty()) {
            return productRepository.findByTipo(TipoProducto.SUPLEMENTO).stream()
                    .filter(p -> categoriasFiltro.contains(p.getCategoria()))
                    .toList();
        }
        return productRepository.findByTipo(TipoProducto.SUPLEMENTO);
    }

    public List<Product> obtenerAccesorios(List<String> categoriasFiltro) {
        if (categoriasFiltro != null && !categoriasFiltro.isEmpty()) {
            return productRepository.findByTipo(TipoProducto.ACCESORIO).stream()
                    .filter(p -> categoriasFiltro.contains(p.getCategoria()))
                    .toList();
        }
        return productRepository.findByTipo(TipoProducto.ACCESORIO);
    }

    public List<Product> obtenerTodos() {
        return productRepository.findAll();
    }

    public Product obtenerProductoPorId(Long id) {
        return productRepository.findById(id).orElseThrow(() ->
                new IllegalArgumentException("Producto con ID " + id + " no encontrado.")
        );
    }

    public List<Product> buscar(String termino) {
        if (termino == null || termino.trim().isEmpty()) {
            return productRepository.findAll();
        }
        return productRepository.buscar(termino.trim());
    }

    /**
     * Retorna hasta 4 productos de cross-selling aleatorios de la misma categoría/tipo,
     * excluyendo el producto actual (motor de recomendaciones al estilo Amazon).
     */
    public List<Product> getCrossSelling(Product producto) {
        List<Product> candidatos = productRepository.findCrossSelling(
                producto.getId(),
                producto.getCategoria(),
                producto.getTipo()
        );
        // Mezcla adicional en memoria para máxima aleatoriedad y limita a 4
        Collections.shuffle(candidatos);
        return candidatos.stream().limit(4).toList();
    }

    /**
     * Retorna hasta 6 suplementos reales filtrados por el objetivo del atleta,
     * para mostrar tarjetas de producto en la vista de plan generado.
     */
    public List<Product> getSuplementosRealesPorObjetivo(ObjetivoPrincipal objetivo) {
        List<String> categorias = SUPL_CATEGORIAS_POR_OBJETIVO
                .getOrDefault(objetivo, List.of("proteinas"));
        List<Product> lista = productRepository.findSuplementosPorCategorias(categorias);
        Collections.shuffle(lista);
        return lista.stream().limit(6).toList();
    }

    public String[] getCategoriasEquipamiento() {
        return new String[]{"racks", "poleas", "prensas", "bancos", "smith", "fuerza"};
    }

    public String[] getCategoriasSuplementos() {
        return new String[]{"proteinas", "creatinas", "preentrenos", "aminoacidos", "salud"};
    }

    public String[] getCategoriasAccesorios() {
        return new String[]{"proteccion", "agarre", "hidratacion", "funcional", "recuperacion", "pesas", "fuerza", "medicion", "transporte"};
    }
}
