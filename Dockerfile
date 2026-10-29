# ===================================================================
# KinexStore — Dockerfile Multi-stage Build
# Arquitectura: Compilación optimizada Maven + Runtime JRE 21 Alpine
# ===================================================================

# -------------------------------------------------------------------
# ETAPA 1: Compilación y empaquetado del WAR auto-ejecutable
# -------------------------------------------------------------------
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder

WORKDIR /build

# Copiar configuración de dependencias para aprovechar la caché de Docker
COPY kinexstore-spring/pom.xml .
RUN mvn dependency:go-offline -B

# Copiar el código fuente completo y compilar
COPY kinexstore-spring/src ./src
RUN mvn clean package -DskipTests

# -------------------------------------------------------------------
# ETAPA 2: Entorno de ejecución ligero y seguro (Endurecimiento)
# -------------------------------------------------------------------
FROM eclipse-temurin:21-jre-alpine AS runner

WORKDIR /app

# Crear usuario y grupo de sistema sin privilegios de root (Seguridad DevSecOps)
RUN addgroup -S kinexgroup && adduser -S kinexuser -G kinexgroup

# Copiar el artefacto resultante de la etapa anterior
COPY --from=builder /build/target/kinexstore-spring-0.0.1-SNAPSHOT.war app.war

# Otorgar propiedad al usuario sin privilegios
RUN chown -R kinexuser:kinexgroup /app

# Cambiar a usuario no root
USER kinexuser

# Exponer el puerto del servicio Tomcat embebido
EXPOSE 8080

# Parámetros de optimización JVM en contenedores
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Dfile.encoding=UTF-8"

# Verificación de salud integrada con Spring Boot Actuator
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Comando de arranque del servicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.war"]
