package co.kinexstore.repositories;

import co.kinexstore.enums.TipoPromo;
import co.kinexstore.models.Promotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PromotionRepository extends JpaRepository<Promotion, Long> {

    Optional<Promotion> findByCodigoAndActivaTrue(String codigo);

    List<Promotion> findByActivaTrue();

    List<Promotion> findByTipoAndActivaTrue(TipoPromo tipo);
}
