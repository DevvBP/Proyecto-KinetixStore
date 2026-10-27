package co.kinexstore.services;

import co.kinexstore.enums.EstadoOrden;
import co.kinexstore.enums.EstadoPlan;
import co.kinexstore.enums.Rol;
import co.kinexstore.enums.TipoProducto;
import co.kinexstore.models.*;
import co.kinexstore.repositories.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    private final PromotionRepository promotionRepository;
    private final PlanAssignmentRepository planAssignmentRepository;

    @Transactional(readOnly = true)
    public Map<String, Object> getMetricasDashboard() {
        Map<String, Object> metrics = new HashMap<>();
        List<Order> ordenes = orderRepository.findAll();
        double ventasMes = ordenes.stream().mapToDouble(Order::getTotal).sum();
        long pedidosPendientes = ordenes.stream().filter(o -> o.getEstado() == EstadoOrden.PENDIENTE).count();
        int alertasStockBajo = productRepository.findByStockLessThanEqual(5).size();
        long totalClientes = userRepository.count();
        long planesPendientes = planAssignmentRepository.findByEstado(EstadoPlan.PENDIENTE).size();

        metrics.put("ventasMesCOP", ventasMes);
        metrics.put("ventasMesFormateado", String.format("$ %,.0f COP", ventasMes).replace(",", "."));
        metrics.put("pedidosPendientes", pedidosPendientes);
        metrics.put("alertasStockBajo", alertasStockBajo);
        metrics.put("totalClientes", totalClientes);
        metrics.put("planesPendientes", planesPendientes);
        metrics.put("ultimosPedidos", ordenes.stream().limit(5).toList());
        metrics.put("productosBajoStock", productRepository.findByStockLessThanEqual(5));
        return metrics;
    }

    @Transactional(readOnly = true)
    public List<Product> listarMaquinaria() {
        return productRepository.findByTipo(TipoProducto.EQUIPAMIENTO);
    }

    @Transactional(readOnly = true)
    public Optional<Product> obtenerProducto(Long id) {
        return productRepository.findById(id);
    }

    @Transactional
    public Product guardarProducto(Product p) {
        return productRepository.save(p);
    }

    @Transactional
    public boolean eliminarProducto(Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Transactional(readOnly = true)
    public List<Product> listarSuplementos() {
        return productRepository.findByTipo(TipoProducto.SUPLEMENTO);
    }

    @Transactional(readOnly = true)
    public List<Order> listarPedidos(EstadoOrden filtroEstado) {
        if (filtroEstado == null) return orderRepository.findByOrderByFechaCreacionDesc();
        return orderRepository.findByEstado(filtroEstado);
    }

    @Transactional(readOnly = true)
    public Optional<Order> obtenerPedido(Long id) {
        return orderRepository.findById(id);
    }

    @Transactional
    public boolean actualizarEstadoPedido(Long id, EstadoOrden nuevoEstado, String guia, String transportadora, String notas) {
        return orderRepository.findById(id).map(order -> {
            order.setEstado(nuevoEstado);
            if (guia != null) order.setNumeroGuia(guia);
            if (transportadora != null) order.setTransportadora(transportadora);
            if (notas != null) order.setNotasLogistica(notas);
            orderRepository.save(order);
            return true;
        }).orElse(false);
    }

    @Transactional(readOnly = true)
    public List<PlanAssignment> listarPlanes(EstadoPlan filtroEstado) {
        if (filtroEstado == null) return planAssignmentRepository.findByOrderByFechaSolicitudDesc();
        return planAssignmentRepository.findByEstado(filtroEstado);
    }

    @Transactional(readOnly = true)
    public Optional<PlanAssignment> obtenerPlan(Long id) {
        return planAssignmentRepository.findById(id);
    }

    @Transactional
    public boolean actualizarEntregaPlan(Long id, String entrenador, String rutina, String dieta, String pdfNombre, EstadoPlan estado) {
        return planAssignmentRepository.findById(id).map(plan -> {
            if (entrenador != null) plan.setEntrenadorAsignado(entrenador);
            if (rutina != null) plan.setRutinaDetalleTexto(rutina);
            if (dieta != null) plan.setDietaDetalleTexto(dieta);
            if (pdfNombre != null) plan.setArchivoPdfNombre(pdfNombre);
            if (estado != null) plan.setEstado(estado);
            planAssignmentRepository.save(plan);
            return true;
        }).orElse(false);
    }

    @Transactional(readOnly = true)
    public List<User> listarUsuarios(String busqueda) {
        if (busqueda == null || busqueda.trim().isEmpty()) {
            return userRepository.findAll();
        }
        return userRepository.findAll().stream()
                .filter(u -> (u.getNombre() + " " + u.getApellido() + " " + u.getEmail()).toLowerCase().contains(busqueda.toLowerCase()))
                .toList();
    }

    @Transactional
    public boolean cambiarRolUsuario(Long id, Rol nuevoRol) {
        return userRepository.findById(id).map(user -> {
            user.setRol(nuevoRol);
            userRepository.save(user);
            return true;
        }).orElse(false);
    }

    @Transactional
    public boolean toggleEstadoUsuario(Long id) {
        return userRepository.findById(id).map(user -> {
            user.setActivo(!user.isActivo());
            userRepository.save(user);
            return true;
        }).orElse(false);
    }

    @Transactional(readOnly = true)
    public List<Promotion> listarPromociones() {
        return promotionRepository.findAll();
    }

    @Transactional
    public Promotion guardarPromocion(Promotion p) {
        return promotionRepository.save(p);
    }

    @Transactional
    public boolean togglePromocion(Long id) {
        return promotionRepository.findById(id).map(promo -> {
            promo.setActiva(!promo.isActiva());
            promotionRepository.save(promo);
            return true;
        }).orElse(false);
    }

    @Transactional
    public boolean eliminarPromocion(Long id) {
        if (promotionRepository.existsById(id)) {
            promotionRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
