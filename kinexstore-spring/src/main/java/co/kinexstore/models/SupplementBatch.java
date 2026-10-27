package co.kinexstore.models;

import co.kinexstore.enums.EstadoCaducidad;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "supplement_batches")
public class SupplementBatch implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "producto_id", nullable = false)
    private Long productoId;

    @Column(name = "producto_nombre", length = 150)
    private String productoNombre;

    @Column(name = "numero_lote", nullable = false, length = 50)
    private String numeroLote;

    @Column(name = "fecha_fabricacion")
    private LocalDate fechaFabricacion;

    @Column(name = "fecha_vencimiento", nullable = false)
    private LocalDate fechaVencimiento;

    @Column(name = "cantidad_stock", nullable = false)
    private int cantidadStock;

    @Column(length = 150)
    private String laboratorio;

    @Column(name = "registro_invima", length = 50)
    private String registroInvima;

    public long getDiasParaVencer() {
        if (fechaVencimiento == null) return 0;
        return ChronoUnit.DAYS.between(LocalDate.now(), fechaVencimiento);
    }

    public EstadoCaducidad getEstadoCaducidad() {
        long dias = getDiasParaVencer();
        if (dias <= 0) return EstadoCaducidad.VENCIDO;
        if (dias <= 90) return EstadoCaducidad.POR_VENCER;
        return EstadoCaducidad.OPTIMO;
    }
}
