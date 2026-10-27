package co.kinexstore.repositories;

import co.kinexstore.models.SupplementBatch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface SupplementBatchRepository extends JpaRepository<SupplementBatch, Long> {

    List<SupplementBatch> findByProductoId(Long productoId);

    List<SupplementBatch> findByFechaVencimientoBefore(LocalDate fecha);
}
