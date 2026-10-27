# KinexStore

Plataforma de comercio electrónico y panel de administración (Back-Office) especializada en equipamiento fitness de alto rendimiento y suplementación deportiva.

El sistema integra un catálogo completo con cálculo logístico de peso dual (kg/lbs) para maquinaria pesada, trazabilidad por lote y registro INVIMA para suplementos, un generador de planes de entrenamiento personalizados, carrito de compras persistente y un módulo administrativo para la gestión de inventario, pedidos y usuarios.

---

## Características Principales

- **Catálogo de Maquinaria Pesada:** Cálculo de fletes industriales según el peso total, especificaciones técnicas y dimensiones de cada equipo.
- **Catálogo de Suplementación:** Control de fechas de vencimiento, números de lote y registro sanitario.
- **Planes Personalizados:** Generador interactivo de rutinas y recomendaciones de suplementos según nivel, objetivo y frecuencia de entrenamiento.
- **Carrito y Checkout:** Persistencia de productos en sesión y validación de usuarios para órdenes de compra.
- **Panel Administrativo (`/admin`):** Métricas clave del negocio, gestión CRUD de productos, semáforo de vencimientos, control de pedidos y administración de cuentas.

---

## Tecnologías Utilizadas

- **Lenguaje:** Java 17 / 21
- **Framework:** Spring Boot 3.4
- **Persistencia:** Spring Data JPA con Hibernate ORM
- **Base de Datos:** MySQL 8.x
- **Frontend:** JSP (Jakarta JSTL 3.0), HTML5, CSS3, JavaScript
- **Gestor de Dependencias:** Apache Maven (vía Maven Wrapper)

---

## Requisitos Previos

Antes de ejecutar el proyecto, asegúrate de tener instalado:

1. **Java Development Kit (JDK):** Versión 17 o 21.
2. **MySQL Server:** Versión 8.0 o superior en ejecución en el puerto `3306`.
3. **Git:** Para control de versiones.

---

## Configuración de la Base de Datos

El proyecto está configurado para conectarse a MySQL y crear la base de datos automáticamente si no existe (`createDatabaseIfNotExist=true`).

Si necesitas ajustar el usuario o contraseña de tu base de datos local, edita el archivo:
`kinexstore-spring/src/main/resources/application.properties`

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/kinexstore_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=TU_CONTRASEÑA
```

Al iniciar la aplicación por primera vez, se generarán las tablas y se sembrarán datos iniciales de prueba (productos, usuarios y promociones).

---

## Cómo Ejecutar el Proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/DevvBP/Proyecto-KinetixStore.git
cd Proyecto-KinetixStore
```

### 2. Iniciar el servidor

Accede al directorio del proyecto Spring Boot y usa el Maven Wrapper:

**En Windows (PowerShell / CMD):**
```powershell
cd kinexstore-spring
.\mvnw.cmd spring-boot:run
```

**En Linux / macOS:**
```bash
cd kinexstore-spring
./mvnw spring-boot:run
```

Una vez iniciado, la consola mostrará que Tomcat arrancó en el puerto `8080`.

---

## Acceso en el Navegador

- **Tienda Principal (E-commerce):**  
  [http://localhost:8080/](http://localhost:8080/)

- **Panel de Administración (Back-Office):**  
  [http://localhost:8080/admin](http://localhost:8080/admin)

---

## Credenciales de Prueba

La base de datos se inicializa con los siguientes usuarios predeterminados:

| Rol | Correo Electrónico | Contraseña |
| :--- | :--- | :--- |
| **Administrador** | `admin@kinexstore.co` | `admin` |
| **Cliente** | `carlos.gomez@gmail.com` | `cliente` |

---

## Estructura del Proyecto

```text
├── admin.html                          # Maqueta estática de referencia
├── PROJECT_CONTEXT_FULL.md             # Documentación técnica extendida
├── README.md                           # Guía general de uso e instalación
└── kinexstore-spring/                  # Proyecto Spring Boot
    ├── pom.xml                         # Dependencias y configuración Maven
    ├── mvnw / mvnw.cmd                 # Maven Wrapper
    └── src/main/
        ├── java/co/kinexstore/
        │   ├── config/                 # Configuración web e inicialización de datos
        │   ├── controllers/            # Controladores web (Ecommerce y Admin)
        │   ├── dtos/                   # Objetos de transferencia de datos
        │   ├── enums/                  # Enumeraciones de dominio
        │   ├── models/                 # Entidades JPA
        │   ├── repositories/           # Interfaces de acceso a datos Spring Data
        │   └── services/               # Lógica de negocio
        ├── resources/
        │   ├── application.properties  # Configuración de entorno y base de datos
        │   └── static/assets/          # Estilos, scripts y multimedia
        └── webapp/
            └── WEB-INF/views/          # Vistas JSP (tienda y panel admin)
```
