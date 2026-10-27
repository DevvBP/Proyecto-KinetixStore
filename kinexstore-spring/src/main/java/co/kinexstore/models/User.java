package co.kinexstore.models;

import co.kinexstore.enums.Rol;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entidad JPA que representa un Usuario en KinexStore.
 * Mapeada a la tabla 'users' en MySQL.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "users")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false, length = 100)
    private String apellido;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(length = 30)
    private String telefono;

    @Column(length = 255)
    private String direccion;

    // Campos de envío internacional / nacional
    @Column(length = 100)
    private String pais;

    @Column(name = "estado_provincia", length = 100)
    private String estadoProvincia;

    @Column(length = 100)
    private String ciudad;

    @Column(name = "codigo_postal", length = 20)
    private String codigoPostal;

    @Column(name = "direccion_detallada", length = 255)
    private String direccionDetallada;

    @Enumerated(EnumType.STRING)
    @Column(length = 30, nullable = false)
    private Rol rol;

    @Column(name = "fecha_registro", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime fechaRegistro = LocalDateTime.now();

    @Column(nullable = false)
    @Builder.Default
    private boolean activo = true;

    // ----------------------------------------------------------------
    // Métodos de negocio y utilidades
    // ----------------------------------------------------------------
    public String getNombreCompleto() {
        return nombre + " " + apellido;
    }

    public boolean tieneRol(Rol rolRequerido) {
        return this.rol == rolRequerido;
    }

    public boolean esAdmin() {
        return this.rol == Rol.ADMINISTRADOR;
    }

    @PrePersist
    public void prePersist() {
        if (this.fechaRegistro == null) {
            this.fechaRegistro = LocalDateTime.now();
        }
        if (this.rol == null) {
            this.rol = Rol.CLIENTE;
        }
    }
}
