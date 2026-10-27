package co.kinexstore.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Configuración de recursos estáticos para KinexStore.
 *
 * En Tomcat embebido con WAR, los archivos bajo src/main/webapp
 * son servidos automáticamente por el contenedor Servlet.
 * Sin embargo, para garantizar el acceso correcto a /assets/**
 * se registra explícitamente el handler apuntando a /assets/ dentro
 * del directorio webapp (interpretado por el servlet container como
 * el root del contexto web).
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Sirve src/main/webapp/assets/** como recursos estáticos en /assets/**
        // La ruta "classpath:/static/" es fallback para assets empaquetados en JAR.
        registry.addResourceHandler("/assets/**")
                .addResourceLocations(
                        "/assets/",                   // webapp/assets/ (prioridad en Tomcat embebido)
                        "classpath:/static/assets/"   // fallback para JAR standalone
                )
                .setCachePeriod(3600);
    }
}
