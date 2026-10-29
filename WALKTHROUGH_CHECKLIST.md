# 📋 KinexStore — Bitácora de Implementación y Checklist de Control

Este documento certifica y documenta la culminación de las fases de expansión de catálogo, exportación de planes a PDF, pruebas unitarias, endurecimiento de seguridad con BCrypt, APIs RESTful con Swagger y contenedorización con Docker Multi-stage.

---

## ✅ Checklist de Entregables por Prioridad

### Fase 1: Catálogo, PDF y Pruebas Unitarias

- [x] **Catálogo de Accesorios:**
  - [x] Vista JSP creada: `kinexstore-spring/src/main/webapp/WEB-INF/views/accessories.jsp`.
  - [x] Ruta `/catalogo/accesorios` mapeada en `EcommerceController.java`.
  - [x] Enum `TipoProducto.ACCESORIO` integrado en el dominio.
  - [x] Traslado y organización de imágenes de maquinaria, suplementos y accesorios a `/static/assets/img/` y `/webapp/assets/img/` (41 productos oficiales).
  - [x] Sembrado de 16 accesorios en MySQL mediante `DataInitializer.java` con pesos, categorías, dimensiones y precios en COP.
  - [x] Eliminación de carpeta temporal de insumos.
  - [x] Integración de enlaces de navegación en `header.jsp` y `home.jsp`.

- [x] **Generación de Planes en Formato PDF (Exportación):**
  - [x] Dependencia OpenPDF (`com.github.librepdf:openpdf:2.0.3`) integrada en `pom.xml`.
  - [x] Método `exportarPlanPdf` implementado en `PlanService.java`.
  - [x] Endpoints `/planes/{id}/pdf` y `/planes/descargar-pdf` expuestos en `EcommerceController.java`.
  - [x] Botón destacado de descarga en `plan_resultado.jsp`.
  - [x] **Tabla 1:** Plan de Alimentación y Distribución de Macronutrientes (horarios, alimentos, calorías, P, C, G y fila de totales).
  - [x] **Tabla 2:** Protocolo de Suplementación Recomendada (suplemento oficial, dosis diaria, timing e instrucciones clínicas).
  - [x] **Tabla 3:** Rutina de Entrenamiento Semanal distribuida (días según elección del usuario, ejercicios principales, series x reps, escala RPE y tiempos de descanso).

- [x] **Pruebas Unitarias (Unidad 10):**
  - [x] `CartServiceTest.java` (6 pruebas unitarias con Mockito y JUnit 5 probando adición, acumulación, subtotales, totales con flete y conversión dual a libras).
  - [x] `PlanServiceTest.java` (3 pruebas unitarias verificando persistencia con Mocking, descripción según días/nivel y validación de encabezado mágico `%PDF-`).
  - [x] `KinexstoreSpringApplicationTests.java` (prueba de carga del contexto Spring Boot).
  - [x] Resultado de compilación y pruebas: `10/10 tests passed (BUILD SUCCESS)`.

---

### Fase 2: Endurecimiento, Docker y DevSecOps

- [x] **Seguridad y BCrypt (Unidad 9):**
  - [x] Dependencia `spring-security-crypto` configurada.
  - [x] Configuración centralizada `SecurityBeansConfig.java` con bean `PasswordEncoder (BCryptPasswordEncoder)`.
  - [x] Hasheo seguro de contraseñas de Administrador y Cliente en `DataInitializer.java`.
  - [x] Encriptación de contraseñas en el registro de usuarios (`/registro`).
  - [x] Verificación mediante `passwordEncoder.matches(...)` en el inicio de sesión.

- [x] **Endurecimiento, Logging y APIs (Unidad 11):**
  - [x] Cero uso de `System.out.println`, estandarizado con anotaciones `@Slf4j` y SLF4J loggers.
  - [x] `GlobalExceptionHandler.java` (@ControllerAdvice) con captura elegante de errores y soporte dual (JSON para API REST y vista `error.jsp` para web).
  - [x] Dependencia `springdoc-openapi-starter-webmvc-ui:2.8.5` configurada.
  - [x] Configuración OpenAPI con metadatos en `OpenApiConfig.java`.
  - [x] Controlador REST `ProductRestController.java` (`/api/v1/productos`) decorado con `@Tag`, `@Operation` y `@Parameter`.

- [x] **Monitoreo y Docker Multi-stage (Unidad 12):**
  - [x] Dependencia `spring-boot-starter-actuator` integrada.
  - [x] Endpoints `/actuator/health`, `/actuator/info` y `/actuator/metrics` expuestos en `application.properties`.
  - [x] `Dockerfile` multi-etapa en la raíz:
    - *Stage 1 (Builder):* Maven 3.9 + Temurin JDK 21 Alpine con caché de dependencias.
    - *Stage 2 (Runner):* Eclipse Temurin JRE 21 Alpine ligero, usuario no-root (`kinexuser`), `HEALTHCHECK` activo y optimización de memoria JVM.
  - [x] Archivo `.dockerignore` configurado en la raíz.

---

## 🛠️ Arquitectura Técnica de la Generación de Planes PDF

La exportación en PDF implementada en `PlanService.java` sigue las directrices de Clean Architecture y no depende del frontend:

1. **Motor de Renderizado:** Se utiliza la librería OpenPDF (versión compatible con Java 17/21 y modularidad de Jakarta EE).
2. **Generación en Memoria (In-Memory Streaming):**
   - El documento no requiere escritura en disco local temporal, evitando problemas de permisos o concurrencia.
   - Utiliza un `ByteArrayOutputStream` conectado a un `PdfWriter`.
3. **Estructura Visual:**
   - **Formato:** Página A4 vertical con márgenes técnicos de 30 puntos.
   - **Paleta Gráfica:** Identidad corporativa KinexStore (Slate 900 `#0f172a`, Slate 800 `#1e293b`, Acento Amber `#d97706`, Slate 200 `#e2e8f0`).
   - **Bloque de Metadatos del Atleta:** Cuadrícula con nombre, email, objetivo, nivel, peso dual (kg y lbs), estatura, lugar de entrenamiento y preferencia dietaria.
   - **Tabla 1 (Nutrición y Macros):** 6 columnas con desglose horario de alimentos, calorías y macronutrientes (P/C/G) más fila de balance total diario.
   - **Tabla 2 (Suplementación):** 4 columnas con suplementos específicos basados en el objetivo, dosis clínica, momento de ingesta y justificación fisiológica.
   - **Tabla 3 (Rutina de Entrenamiento):** 5 columnas dinámicas según los días seleccionados (Full Body para 3 días, Torso/Pierna para 4 días, Push/Pull/Legs para 5-6 días), incluyendo series, repeticiones, escala RPE y tiempos de recuperación.
4. **Entrega HTTP:**
   - `EcommerceController` expone `/planes/{id}/pdf` y `/planes/descargar-pdf`.
   - Cabeceras: `Content-Type: application/pdf` y `Content-Disposition: attachment; filename="Plan_KinexStore_<objetivo>.pdf"`.
