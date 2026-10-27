package co.kinexstore.repositories;

import co.kinexstore.enums.EstadoPlan;
import co.kinexstore.models.PlanAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PlanAssignmentRepository extends JpaRepository<PlanAssignment, Long> {

    List<PlanAssignment> findByClienteEmail(String clienteEmail);

    List<PlanAssignment> findByEstado(EstadoPlan estado);

    List<PlanAssignment> findByOrderByFechaSolicitudDesc();
}
