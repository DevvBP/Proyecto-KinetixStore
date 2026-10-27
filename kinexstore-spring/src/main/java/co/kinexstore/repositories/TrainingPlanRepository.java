package co.kinexstore.repositories;

import co.kinexstore.enums.NivelExperiencia;
import co.kinexstore.models.TrainingPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrainingPlanRepository extends JpaRepository<TrainingPlan, Long> {

    List<TrainingPlan> findByEmailUsuario(String emailUsuario);

    List<TrainingPlan> findByNivel(NivelExperiencia nivel);
}
