package co.kinexstore.repositories;

import co.kinexstore.enums.EstadoOrden;
import co.kinexstore.models.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    Optional<Order> findByNumeroOrden(String numeroOrden);

    List<Order> findByClienteEmail(String clienteEmail);

    List<Order> findByEstado(EstadoOrden estado);

    List<Order> findByOrderByFechaCreacionDesc();
}
