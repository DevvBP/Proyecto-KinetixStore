# 🏋️ KinexStore — Contexto Integral y Documento Maestro de Arquitectura

> **Documento:** `PROJECT_CONTEXT_FULL.md`  
> **Propósito:** Proveer a cualquier Inteligencia Artificial o desarrollador el contexto exhaustivo, 100% fiel al código real, de la arquitectura, carpetas, archivos, modelos de datos, flujos de negocio y estado del proyecto tras la estabilización y refactorización completa.  
> **Versión del Proyecto:** 2.1.0 (Clean Architecture, Enums Autónomos, Catálogo 27 Productos, Carrito Persistente y Checkout Seguro)  
> **Versión de Java:** Java 17 LTS / OpenJDK 21  
> **Framework Base:** Spring Boot 3.4.3  
> **Base de Datos:** MySQL 8.x (`kinexstore_db`) vía Hibernate ORM  
> **Frontend:** JSP + Jakarta JSTL 3.0 + Tailwind CSS + Vanilla CSS / JS  
> **Estado de Compilación:** `BUILD SUCCESS` (`mvn clean package`)  

---

## 1. 📌 Resumen Ejecutivo del Negocio y del Software

**KinexStore** es una plataforma de comercio electrónico de alto rendimiento y suite de gestión (Back-Office) especializada en dos líneas verticales clave del sector fitness y musculación:
1. **Maquinaria y Equipamiento Pesado (21 Equipos Oficiales):** Racks de potencia, prensas de piernas de 45°, máquinas Smith, poleas funcionales, máquinas selectorizadas (pecho, tríceps, bíceps, glúteos, abdominales, gemelos, dominadas asistidas). Requiere logística especializada de carga pesada (>50 kg = Flete Industrial Pesado), cubicaje y doble lectura de peso internacional (**kg y lbs**).
2. **Suplementación Deportiva de Grado Clínico (6 Productos Oficiales):** Proteínas aisladas (Whey), creatina Creapure®, pre-entrenos nootrópicos, BCAA fermentados, Omega 3 y Mass Gainer. Requiere trazabilidad por número de lote, fecha de vencimiento y registro sanitario legal (INVIMA / Colombia).
3. **Planes de Entrenamiento y Nutrición Personalizados:** Motor interactivo de recomendación que genera planes de entrenamiento (Full Body, Upper/Lower, PPL) y asigna combinaciones de suplementos según nivel, frecuencia semanal y objetivo físico.
4. **Flujo de Checkout y Carrito Inteligente:** Los usuarios visitantes pueden explorar y llenar su carrito sin restricciones. Al momento de pulsar "Finalizar Compra", el sistema protege la ruta `/checkout` redirigiendo al registro validado (`UsuarioRegistroDTO`), garantizando que **el carrito de compras de la sesión no se pierda** y se fusione automáticamente con la nueva cuenta creada.

---

## 2. 🌳 Árbol Completo de Carpetas y Archivos del Workspace

Tras la eliminación de la versión legacy (`kinexstore-mvc`) y scripts obsoletos, el espacio de trabajo queda 100% limpio y autónomo en **`kinexstore-spring`**:

```
c:\Users\braya\Desktop\kinexstore-package (2)\
├── .vscode/                                  # Configuración de editor y análisis Java
├── admin.html                                # Maqueta estática HTML/Tailwind original de referencia
├── KINEXSTORE_ADMIN_WALKTHROUGH.md           # Bitácora detallada de la construcción del panel admin
├── KINEXSTORE_MVC_CONTEXT.md                 # Contexto histórico de la versión previa de Servlets
├── KINEXSTORE_SPRING_BOOT_ARCHITECTURE_GUIDE.md # Guía técnica de la arquitectura Spring Boot
├── KINEXSTORE_SPRING_GUIA.md                 # Guía rápida de comandos operativos
├── PROJECT_CONTEXT_FULL.md                   # ESTE DOCUMENTO MAESTRO ACTUALIZADO
│
└── kinexstore-spring/                        # 🚀 [PROYECTO ÚNICO ACTIVO - SPRING BOOT 3]
    ├── pom.xml                               # Web, Data JPA, Validation, MySQL, Jasper, Lombok
    ├── mvnw / mvnw.cmd                       # Maven Wrapper para Windows y Unix
    └── src/
        ├── test/java/kinexstore_spring/
        │   └── KinexstoreSpringApplicationTests.java
        └── main/
            ├── resources/
            │   ├── application.properties    # Conexión MySQL, Hibernate DDL, ViewResolver JSP
            │   └── static/assets/            # Recursos estáticos servidos en JAR
            │       ├── css/styles.css
            │       ├── js/app.js
            │       ├── video/ (hero-1.mp4, hero-2.mp4, hero-3.mp4)
            │       └── img/ (prod-1.jpeg a prod-21.jpeg, supp-*.jpg, bento-*.jpg)
            ├── webapp/                       # Raíz web servida por Tomcat Embebido
            │   ├── index.jsp                 # Redirección automática a /app?accion=home
            │   ├── assets/                   # CSS, imágenes y videos sincronizados con webapp
            │   │   ├── css/styles.css
            │   │   ├── js/app.js
            │   │   ├── img/ (21 productos de maquinaria + 6 suplementos + banners)
            │   │   └── video/ (hero-1.mp4, hero-2.mp4, hero-3.mp4)
            │   └── WEB-INF/
            │       ├── web.xml               # Configuración de timeout de sesión HTTP (30 min)
            │       └── views/                # Vistas JSP seguras compiladas por Jasper
            │           ├── home.jsp          # Landing principal con video hero y categorías
            │           ├── machinery.jsp     # Catálogo de maquinaria con pesos duales (kg/lbs)
            │           ├── supplements.jsp   # Catálogo de suplementos con control INVIMA
            │           ├── cart.jsp          # Carrito con input numérico libre y peso dual
            │           ├── checkout.jsp      # 🛡️ Vista de confirmación de pedido con dirección y flete
            │           ├── training.jsp      # Wizard interactivo para configurar plan fitness
            │           ├── plan_resultado.jsp# Resultado personalizado con suplementación
            │           ├── login.jsp         # Inicio de sesión con credenciales de prueba
            │           ├── registro.jsp      # 📝 Formulario con validación DTO y campos de envío
            │           ├── error.jsp         # Página de error amigable
            │           ├── includes/
            │           │   ├── header.jsp    # Navbar global con contador reactivo
            │           │   └── footer.jsp    # Footer institucional
            │           └── admin/            # 🛡️ Panel de Control Administrativo (Back-Office)
            │               ├── dashboard.jsp # KPIs, métricas de ventas y pedidos recientes
            │               ├── maquinas.jsp  # Gestión CRUD de equipamiento con pesos duales
            │               ├── suplementos.jsp# Control de lotes, semáforo de caducidad e INVIMA
            │               ├── pedidos.jsp   # Gestión de pedidos, guías y transportadoras
            │               ├── planes.jsp    # Asignación de coach y carga de rutinas/PDFs
            │               ├── usuarios.jsp  # Gestión de clientes y alternancia de roles
            │               ├── promos.jsp    # Cupones de descuento y banners rotativos
            │               └── includes/
            │                   ├── admin_header.jsp  # Header superior admin y notificaciones flash
            │                   ├── admin_sidebar.jsp # Sidebar lateral colapsable
            │                   └── admin_footer.jsp  # Modales y scripts admin
            └── java/co/kinexstore/
                ├── KinexstoreSpringApplication.java # @SpringBootApplication (Main Class)
                ├── ServletInitializer.java          # Configuración para despliegue servlet/WAR
                ├── config/
                │   ├── DataInitializer.java        # CommandLineRunner: siembra 27 productos, usuarios y promos
                │   ├── GlobalModelAttributes.java  # @ControllerAdvice: inyecta contextPath y total carrito
                │   └── WebConfig.java              # WebMvcConfigurer: mapeo estático de /assets/**
                ├── controllers/
                │   ├── EcommerceController.java    # Tienda, Catálogos, Carrito, Registro, Checkout
                │   └── AdminController.java        # Suite Back-Office administrativa
                ├── dtos/                           # 📦 Data Transfer Objects validados
                │   └── UsuarioRegistroDTO.java     # DTO con @Email, contraseña segura y campos de envío
                ├── enums/                          # 🏷️ Enums extraídos a archivos independientes
                │   ├── Rol.java                    # ADMINISTRADOR, CLIENTE
                │   ├── TipoProducto.java           # EQUIPAMIENTO, SUPLEMENTO
                │   ├── EstadoOrden.java            # PENDIENTE, EMPACADO, EN_TRANSITO, ENTREGADO, CANCELADO
                │   ├── NivelExperiencia.java       # PRINCIPIANTE, INTERMEDIO, AVANZADO
                │   ├── ObjetivoPrincipal.java      # HIPERTROFIA, FUERZA_MAXIMA, PERDIDA_GRASA, RESISTENCIA
                │   ├── EstadoPlan.java             # PENDIENTE, EN_ELABORACION, ENTREGADO, REVISION
                │   ├── TipoPromo.java              # CUPON, BANNER_HERO, BANNER_SECCION
                │   └── EstadoCaducidad.java        # OPTIMO, POR_VENCER, VENCIDO
                ├── models/                         # Entidades JPA (@Entity) con Lombok
                │   ├── Product.java                # Tabla 'products' con getPesoDual() (kg y lbs)
                │   ├── User.java                   # Tabla 'users' con campos de envío completos
                │   ├── Order.java                  # Tabla 'orders' vinculada a EstadoOrden
                │   ├── TrainingPlan.java           # Tabla 'training_plans'
                │   ├── PlanAssignment.java         # Tabla 'plan_assignments'
                │   ├── Promotion.java              # Tabla 'promotions'
                │   ├── SupplementBatch.java        # Tabla 'supplement_batches'
                │   └── CartItem.java               # POJO DTO para items en sesión (sin incrementar/decrementar)
                ├── repositories/                   # Interfaces Spring Data JPA (@Repository)
                │   ├── ProductRepository.java
                │   ├── UserRepository.java
                │   ├── OrderRepository.java
                │   ├── TrainingPlanRepository.java
                │   ├── PlanAssignmentRepository.java
                │   ├── PromotionRepository.java
                │   └── SupplementBatchRepository.java
                └── services/                       # Capa de Lógica de Negocio (@Service)
                    ├── CatalogService.java         # Categorías de equipamiento y suplementos
                    ├── CartService.java            # Reglas de flete, peso dual y carrito en sesión
                    ├── PlanService.java            # Generación de rutinas y sugerencias
                    └── AdminService.java           # Métricas, KPIs y operaciones administrativas
```

---

## 3. 🏷️ Paquete Autónomo de Enums (`co.kinexstore.enums`)

Todos los Enums fueron desacoplados de las clases del modelo para cumplir con los principios de **Clean Code**, alta cohesión y bajo acoplamiento:

1. **`Rol`**: Contempla exclusivamente roles con credenciales de acceso:
   * `ADMINISTRADOR`: Acceso a Back-Office `/admin` y gestión total.
   * `CLIENTE`: Acceso a tienda, historial de compras y checkout.
   *(Se eliminó el rol superfluo `VISITANTE` ya que los invitados no persisten en la tabla `users`)*.
2. **`TipoProducto`**: `EQUIPAMIENTO`, `SUPLEMENTO`.
3. **`EstadoOrden`**: `PENDIENTE`, `EMPACADO`, `EN_TRANSITO`, `ENTREGADO`, `CANCELADO`.
4. **`NivelExperiencia`**: `PRINCIPIANTE`, `INTERMEDIO`, `AVANZADO`.
5. **`ObjetivoPrincipal`**: `HIPERTROFIA`, `FUERZA_MAXIMA`, `PERDIDA_GRASA`, `RESISTENCIA`.
6. **`EstadoPlan`**: `PENDIENTE`, `EN_ELABORACION`, `ENTREGADO`, `REVISION`.
7. **`TipoPromo`**: `CUPON`, `BANNER_HERO`, `BANNER_SECCION`.
8. **`EstadoCaducidad`**: `OPTIMO`, `POR_VENCER`, `VENCIDO`.

---

## 4. ⚖️ Internacionalización y Cálculo Dual de Peso (Kg y Lbs)

Para clientes de maquinaria de exportación y compatibilidad con estándares internacionales, se implementó el factor de conversión exacto:
$$\text{Libras (lbs)} = \text{Kilogramos (kg)} \times 2.20462$$

* **Métodos incorporados:**
  * En `Product.java`:
    * `getPesoLbs()`: Retorna el peso en libras con precisión de punto flotante.
    * `getPesoDual()`: Retorna el String formateado `"180.0 kg (396.83 lbs)"`.
  * En `CartItem.java`:
    * `getPesoTotalLbs()`: Peso del renglón en libras.
    * `getPesoTotalDual()`: Formato dual de peso total por producto en carrito.
* **Presencia en Vistas:**
  * `machinery.jsp`: Cada tarjeta de producto muestra `⚖️ 180.0 kg (396.83 lbs)` junto a sus dimensiones.
  * `cart.jsp`: Cada ítem muestra el peso dual, y el resumen inferior calcula el peso total acumulado en kg y lbs.
  * `checkout.jsp`: Desglose del cubicaje total del pedido para cálculo transparente del flete.
  * `admin/maquinas.jsp`: La tabla de administración refleja el peso en ambas unidades de medida.

---

## 5. 🛒 UX del Carrito: Entrada Numérica Libre

Se refactorizó la experiencia de usuario del carrito de compras:
* **Eliminación de código heredado:** Se eliminaron los métodos `incrementar()` y `decrementar()` de `CartItem.java`.
* **Entrada directa:** En `cart.jsp`, se reemplazaron los botones `+` y `-` por un input numérico:
  ```html
  <input type="number" name="cantidad" value="${item.cantidad}" min="1" max="99" onchange="this.form.submit()">
  ```
  Permite al usuario tipear directamente cualquier cantidad (ej. 10 racks para gimnasio comercial) y se actualiza instantáneamente vía AJAX/submit sin tener que pulsar el botón diez veces.

---

## 6. 📦 Integración del Catálogo de Maquinaria (21 Productos)

Las 21 imágenes de maquinaria pesada fueron migradas a `assets/img/prod-1.jpeg` hasta `prod-21.jpeg` tanto en `src/main/resources/static/assets/img/` como en `src/main/webapp/assets/img/`.

En `DataInitializer.java`, se siembran los 21 equipos con especificaciones técnicas completas derivadas del documento oficial:
1. `prod-1.jpeg`: **Jalón al Pecho y Remo Bajo Pro** (Poleas · $4.800.000 COP · 180 kg)
2. `prod-2.jpeg`: **Prensa Inclinada de Piernas 45°** (Prensas · $5.800.000 COP · 220 kg)
3. `prod-3.jpeg`: **Máquina Smith Comercial 3D** (Smith · $5.990.000 COP · 180 kg)
4. `prod-4.jpeg`: **Doble Polea Ajustable Dual Pulley** (Poleas · $4.200.000 COP · 220 kg)
5. `prod-5.jpeg`: **Extensión de Piernas Selectorizada** (Fuerza · $2.400.000 COP · 120 kg)
6. `prod-6.jpeg`: **Prensa de Pecho Sentado Chest Press** (Fuerza · $3.200.000 COP · 140 kg)
7. `prod-7.jpeg`: **Prensa de Piernas Lineal Heavy Duty** (Prensas · $6.100.000 COP · 235 kg)
8. `prod-8.jpeg`: **Sillón de Cuádriceps Leg Extension Pro** (Fuerza · $2.550.000 COP · 125 kg)
9. `prod-9.jpeg`: **Jalón Dorsal High Pulley Lat** (Poleas · $3.450.000 COP · 160 kg)
10. `prod-10.jpeg`: **Curl Femoral Tumbado Lying Leg Curl** (Fuerza · $2.700.000 COP · 135 kg)
11. `prod-11.jpeg`: **Contractor de Pecho Pec Deck Fly** (Fuerza · $2.950.000 COP · 145 kg)
12. `prod-12.jpeg`: **Press de Hombros Sentado Shoulder Press** (Fuerza · $3.100.000 COP · 140 kg)
13. `prod-13.jpeg`: **Remo Sentado Low Row Cable** (Poleas · $3.300.000 COP · 155 kg)
14. `prod-14.jpeg`: **Dominadas y Fondos Asistidos Dip-Chin** (Fuerza · $4.500.000 COP · 190 kg)
15. `prod-15.jpeg`: **Máquina de Bíceps Bicep Curl Scott** (Fuerza · $2.500.000 COP · 120 kg)
16. `prod-16.jpeg`: **Máquina de Tríceps Tricep Pushdown** (Fuerza · $2.600.000 COP · 130 kg)
17. `prod-17.jpeg`: **Máquina de Glúteos y Abductores Outer Thigh** (Fuerza · $2.900.000 COP · 150 kg)
18. `prod-18.jpeg`: **Elevación de Gemelos de Pie Standing Calf** (Fuerza · $2.800.000 COP · 145 kg)
19. `prod-19.jpeg`: **Máquina de Patada de Glúteo Glute Kickback** (Fuerza · $2.750.000 COP · 135 kg)
20. `prod-20.jpeg`: **Máquina de Abdominales Crunch Machine** (Fuerza · $2.450.000 COP · 115 kg)
21. `prod-21.jpeg`: **Torre Crossover Cable Cruce de Poleas** (Poleas · $6.500.000 COP · 290 kg)
* Más los 6 suplementos clínicos de alta pureza (Whey Protein, Creatina Creapure, Pre-Workout, BCAA, Omega 3, Mass Gainer). Total: **27 productos oficiales sembrados**.

---

## 7. 🛡️ Flujo de Registro Validado, Fusión de Carrito y Checkout

### Arquitectura del Flujo:
```
[Invitado agrega productos al Carrito en HttpSession]
                   │
                   ▼
         [Clic en Finalizar Compra]
                   │
                   ▼
      ¿usuarioActual en sesión == null?
         ├── SÍ ──► Guarda en sesión: redirectUrlPostAuth = "/checkout"
         │          Redirige a: /registro?from=checkout
         │                   │
         │                   ▼
         │          [Formulario registro.jsp con DTO]
         │          - Valida @Email y Contraseña Segura
         │          - Captura datos de Envío (País, Depto, Ciudad, Dirección, Código Postal)
         │                   │
         │                   ▼
         │          [Crea Usuario en MySQL y loguea en HttpSession]
         │          ¡EL CARRITO DE INVITADO SIGUE VIVO EN LA SESIÓN! (Fusión Transparente)
         │                   │
         │                   ▼
         │          Detecta redirectUrlPostAuth == "/checkout"
         │          Redirige automáticamente a: /checkout
         │
         └── NO ──► Accede directamente a /checkout
```

### Componentes Clave:
* **`UsuarioRegistroDTO`**: Valida nombre, apellido, correo electrónico (`@Email`), contraseña segura (`@Pattern` con mínimo 8 caracteres, 1 mayúscula y 1 número) y dirección detallada de despacho.
* **`checkout.jsp`**: Muestra la tarjeta del cliente autenticado con su dirección de entrega, desglose de ítems, cálculo del flete y confirmación final de la orden en la tabla `orders`.

---

## 8. 🚀 Manual de Operación y Comandos

### Compilación y Empaquetado
```powershell
cd "c:\Users\braya\Desktop\kinexstore-package (2)\kinexstore-spring"
mvn clean package -DskipTests
```
Genera: `target/kinexstore-spring-0.0.1-SNAPSHOT.war` con Tomcat Jasper embebido.

### Arranque del Servidor
```powershell
.\mvnw.cmd spring-boot:run
```

### URLs Principales
* Tienda pública: `http://localhost:8080/`
* Catálogo Maquinaria: `http://localhost:8080/catalogo/equipamiento`
* Catálogo Suplementos: `http://localhost:8080/catalogo/suplementos`
* Carrito de Compras: `http://localhost:8080/carrito`
* Registro de Usuarios: `http://localhost:8080/registro`
* Checkout Protegido: `http://localhost:8080/checkout`
* Suite Back-Office: `http://localhost:8080/admin`

### Credenciales de Acceso
* **Administrador:** `admin@kinexstore.co` / clave: `admin`
* **Cliente:** `carlos.gomez@gmail.com` / clave: `cliente`
