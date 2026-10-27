package co.kinexstore.repositories;

import co.kinexstore.enums.TipoProducto;
import co.kinexstore.models.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    List<Product> findByTipo(TipoProducto tipo);

    List<Product> findByCategoria(String categoria);

    List<Product> findByDisponibleTrue();

    List<Product> findByStockLessThanEqual(int stock);

    @Query("SELECT p FROM Product p WHERE LOWER(p.nombre) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(p.descripcion) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(p.categoria) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Product> buscar(@Param("query") String query);

    /**
     * Cross-selling: 4 productos de la misma categoría o mismo tipo, excluyendo el producto actual.
     * Los resultados llegan en orden aleatorio (RAND()).
     */
    @Query("SELECT p FROM Product p WHERE p.id <> :id AND (p.categoria = :categoria OR p.tipo = :tipo) AND p.disponible = true ORDER BY function('RAND')")
    List<Product> findCrossSelling(@Param("id") Long id,
                                   @Param("categoria") String categoria,
                                   @Param("tipo") TipoProducto tipo);

    /**
     * Productos de suplementación filtrados por categorías de objetivo.
     * Usado para la sección "Suplementación Recomendada" del plan generado.
     */
    @Query("SELECT p FROM Product p WHERE p.tipo = 'SUPLEMENTO' AND p.categoria IN :categorias AND p.disponible = true ORDER BY function('RAND')")
    List<Product> findSuplementosPorCategorias(@Param("categorias") List<String> categorias);
}
