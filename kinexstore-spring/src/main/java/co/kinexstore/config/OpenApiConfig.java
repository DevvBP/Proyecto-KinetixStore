package co.kinexstore.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("KinexStore RESTful API")
                        .version("2.1.0")
                        .description("Documentación y especificación interactiva de la API de KinexStore para maquinaria pesada, suplementación clínica y accesorios de entrenamiento.")
                        .contact(new Contact()
                                .name("KinexStore Engineering Team")
                                .email("soporte@kinexstore.co")
                                .url("https://github.com/DevvBP/Proyecto-KinetixStore"))
                        .license(new License()
                                .name("Apache 2.0")
                                .url("https://www.apache.org/licenses/LICENSE-2.0")));
    }
}

