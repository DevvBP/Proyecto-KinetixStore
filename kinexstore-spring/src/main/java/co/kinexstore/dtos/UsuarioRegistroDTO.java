package co.kinexstore.dtos;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * Data Transfer Object para el registro validado de usuarios y clientes.
 * Aplica validaciones estrictas con Jakarta Validation.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioRegistroDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotBlank(message = "El nombre es obligatorio")
    @Size(min = 2, max = 100, message = "El nombre debe tener entre 2 y 100 caracteres")
    private String nombre;

    @NotBlank(message = "El apellido es obligatorio")
    @Size(min = 2, max = 100, message = "El apellido debe tener entre 2 y 100 caracteres")
    private String apellido;

    @NotBlank(message = "El correo electrónico es obligatorio")
    @Email(message = "Ingresa un correo electrónico con formato válido")
    private String email;

    @NotBlank(message = "La contraseña es obligatoria")
    @Pattern(
        regexp = "^(?=.*[0-9])(?=.*[A-Z]).{8,}$",
        message = "La contraseña debe tener mínimo 8 caracteres, al menos una letra mayúscula y un número"
    )
    private String password;

    @NotBlank(message = "El teléfono de contacto es obligatorio")
    @Size(min = 7, max = 30, message = "El teléfono debe tener entre 7 y 30 caracteres")
    private String telefono;

    @NotBlank(message = "El país es obligatorio para el flete")
    private String pais;

    @NotBlank(message = "El departamento o provincia es obligatorio")
    private String estadoProvincia;

    @NotBlank(message = "La ciudad de entrega es obligatoria")
    private String ciudad;

    @NotBlank(message = "El código postal es obligatorio")
    private String codigoPostal;

    @NotBlank(message = "La dirección detallada de entrega es obligatoria")
    private String direccionDetallada;
}
