package co.kinexstore.config;

import co.kinexstore.enums.Rol;
import co.kinexstore.enums.TipoProducto;
import co.kinexstore.enums.TipoPromo;
import co.kinexstore.models.Product;
import co.kinexstore.models.Promotion;
import co.kinexstore.models.SupplementBatch;
import co.kinexstore.models.User;
import co.kinexstore.repositories.ProductRepository;
import co.kinexstore.repositories.PromotionRepository;
import co.kinexstore.repositories.SupplementBatchRepository;
import co.kinexstore.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.List;

@Configuration
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final PromotionRepository promotionRepository;
    private final SupplementBatchRepository supplementBatchRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        // Catálogo completo oficial: 21 máquinas + 10 suplementos + 16 accesorios = 47 productos
        if (productRepository.count() < 47) {
            supplementBatchRepository.deleteAll();
            productRepository.deleteAll();
            inicializarCatalogoCompleto();
        }
        // Inicializar o actualizar usuarios con BCrypt
        if (userRepository.count() == 0) {
            inicializarUsuarios();
        } else {
            userRepository.findByEmail("admin@kinexstore.co").ifPresent(admin -> {
                if (!admin.getPasswordHash().startsWith("$2a$")) {
                    admin.setPasswordHash(passwordEncoder.encode("admin"));
                    userRepository.save(admin);
                }
            });
            userRepository.findByEmail("carlos.gomez@gmail.com").ifPresent(cliente -> {
                if (!cliente.getPasswordHash().startsWith("$2a$")) {
                    cliente.setPasswordHash(passwordEncoder.encode("cliente"));
                    userRepository.save(cliente);
                }
            });
        }
        if (promotionRepository.count() == 0) {
            inicializarPromociones();
        }
    }

    private void inicializarCatalogoCompleto() {
        List<Product> productos = List.of(
            // ---- 21 MÁQUINAS Y EQUIPAMIENTO PESADO OFICIALES (ImagenesNuevas) ----
            Product.builder()
                .nombre("Jalón al Pecho y Remo Bajo Pro")
                .descripcion("Estación dual para jalón dorsal al pecho y remo sentado bajo. Sistema de cable ultra fluido, rodillos ajustables y torre de placas.")
                .precio(4800000)
                .pesoKg(180.0)
                .categoria("poleas")
                .imagenPath("assets/img/prod-1.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("180x120x220 cm")
                .descuentoMayoristaPct(10.0)
                .stock(6)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Prensa Inclinada de Piernas 45°")
                .descripcion("Estructura de acero reforzado con plataforma antideslizante extra ancha, respaldo reclinable ergonómico y bloqueo de seguridad.")
                .precio(5800000)
                .pesoKg(220.0)
                .categoria("prensas")
                .imagenPath("assets/img/prod-2.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("220x160x145 cm")
                .descuentoMayoristaPct(12.0)
                .stock(5)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Máquina Smith Comercial 3D")
                .descripcion("Barra guiada con rodamientos lineales de precisión, topes de seguridad ajustables y soporte para discos olímpicos.")
                .precio(5990000)
                .pesoKg(180.0)
                .categoria("smith")
                .imagenPath("assets/img/prod-3.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("150x200x220 cm")
                .descuentoMayoristaPct(10.0)
                .stock(4)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Doble Polea Ajustable Dual Pulley")
                .descripcion("Doble torre de placas con poleas regulables en altura multiaxiales para cruces de cable, aperturas y entrenamiento funcional.")
                .precio(4200000)
                .pesoKg(220.0)
                .categoria("poleas")
                .imagenPath("assets/img/prod-4.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("150x120x220 cm")
                .descuentoMayoristaPct(10.0)
                .stock(7)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Extensión de Piernas Selectorizada")
                .descripcion("Aislamiento focalizado de cuádriceps con rodillo acolchado regulable en ángulo y sistema de placas selectorizado.")
                .precio(2400000)
                .pesoKg(120.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-5.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("130x100x150 cm")
                .descuentoMayoristaPct(8.0)
                .stock(8)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Prensa de Pecho Sentado Chest Press")
                .descripcion("Empuje de pectoral guiado con biomecánica convergente para tensión continua sin sobrecargar los manguitos rotadores.")
                .precio(3200000)
                .pesoKg(140.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-6.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("145x115x165 cm")
                .descuentoMayoristaPct(10.0)
                .stock(6)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Prensa de Piernas Lineal Heavy Duty")
                .descripcion("Máquina de piernas pesada con rieles de acero templado, apta para cargas superiores a 600 kg y plataforma multiángulo.")
                .precio(6100000)
                .pesoKg(235.0)
                .categoria("prensas")
                .imagenPath("assets/img/prod-7.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("230x165x150 cm")
                .descuentoMayoristaPct(12.0)
                .stock(4)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Sillón de Cuádriceps Leg Extension Pro")
                .descripcion("Biomecánica optimizada para desarrollo y definición del recto femoral con agarres laterales de estabilidad.")
                .precio(2550000)
                .pesoKg(125.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-8.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("135x105x155 cm")
                .descuentoMayoristaPct(8.0)
                .stock(9)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Jalón Dorsal High Pulley Lat")
                .descripcion("Estación de tracción vertical con polea alta de alta resistencia y barra ergonómica para espalda en 'V'.")
                .precio(3450000)
                .pesoKg(160.0)
                .categoria("poleas")
                .imagenPath("assets/img/prod-9.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("140x110x225 cm")
                .descuentoMayoristaPct(10.0)
                .stock(5)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Curl Femoral Tumbado Lying Leg Curl")
                .descripcion("Aislamiento completo de isquiotibiales con banco contorneado anatómico para eliminar la presión lumbar.")
                .precio(2700000)
                .pesoKg(135.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-10.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("170x105x140 cm")
                .descuentoMayoristaPct(8.0)
                .stock(7)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Contractor de Pecho Pec Deck Fly")
                .descripcion("Aperturas circulares para bombeo e hipertrofia de la porción esternal del pectoral y deltoides.")
                .precio(2950000)
                .pesoKg(145.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-11.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("135x110x160 cm")
                .descuentoMayoristaPct(10.0)
                .stock(6)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Press de Hombros Sentado Shoulder Press")
                .descripcion("Empuje vertical guiado con agarre doble (neutro y prono) para hombros fuertes y seguros.")
                .precio(3100000)
                .pesoKg(140.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-12.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("140x120x165 cm")
                .descuentoMayoristaPct(10.0)
                .stock(6)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Remo Sentado Low Row Cable")
                .descripcion("Tracción horizontal con reposapiés antideslizantes de ángulo biomecánico para grosor de espalda media.")
                .precio(3300000)
                .pesoKg(155.0)
                .categoria("poleas")
                .imagenPath("assets/img/prod-13.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("190x100x160 cm")
                .descuentoMayoristaPct(10.0)
                .stock(8)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Dominadas y Fondos Asistidos Dip-Chin")
                .descripcion("Plataforma contrapesada regulable para progresión perfecta en calistenia, dorsales, tríceps y core.")
                .precio(4500000)
                .pesoKg(190.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-14.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("150x125x230 cm")
                .descuentoMayoristaPct(10.0)
                .stock(5)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Máquina de Bíceps Bicep Curl Scott")
                .descripcion("Soporte Scott acolchado que fija los codos para aislar y concentrar el pico del bíceps braquial.")
                .precio(2500000)
                .pesoKg(120.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-15.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("125x105x150 cm")
                .descuentoMayoristaPct(8.0)
                .stock(9)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Máquina de Tríceps Tricep Pushdown")
                .descripcion("Extensión de tríceps sentado con levas de tensión constante y respaldo de máximo confort.")
                .precio(2600000)
                .pesoKg(130.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-16.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("140x110x150 cm")
                .descuentoMayoristaPct(8.0)
                .stock(7)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Máquina de Glúteos y Abductores Outer Thigh")
                .descripcion("Apertura guiada para glúteo medio, menor y tensor de la fascia lata con almohadillas ajustables.")
                .precio(2900000)
                .pesoKg(150.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-17.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("160x120x150 cm")
                .descuentoMayoristaPct(10.0)
                .stock(6)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Elevación de Gemelos de Pie Standing Calf")
                .descripcion("Hombreras ergonómicas articuladas y plataforma elevada para máximo rango de estiramiento y contracción de pantorrillas.")
                .precio(2800000)
                .pesoKg(145.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-18.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("130x100x180 cm")
                .descuentoMayoristaPct(10.0)
                .stock(5)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Máquina de Patada de Glúteo Glute Kickback")
                .descripcion("Péndulo biomecánico para extensión de cadera y aislamiento puro del glúteo mayor sin compromiso lumbar.")
                .precio(2750000)
                .pesoKg(135.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-19.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("155x105x155 cm")
                .descuentoMayoristaPct(8.0)
                .stock(6)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Máquina de Abdominales Crunch Machine")
                .descripcion("Flexión de tronco con resistencia de placas para hipertrofia de recto abdominal y oblicuos.")
                .precio(2450000)
                .pesoKg(115.0)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-20.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("130x105x150 cm")
                .descuentoMayoristaPct(8.0)
                .stock(8)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Torre Crossover Cable Cruce de Poleas")
                .descripcion("Mega estructura crossover con dos columnas de poleas ajustables en 20 alturas, barra de dominadas integrada y accesorios incluidos.")
                .precio(6500000)
                .pesoKg(290.0)
                .categoria("poleas")
                .imagenPath("assets/img/prod-21.jpeg")
                .tipo(TipoProducto.EQUIPAMIENTO)
                .dimensiones("350x120x230 cm")
                .descuentoMayoristaPct(15.0)
                .stock(3)
                .disponible(true)
                .build(),

            // ---- SUPLEMENTACIÓN DEPORTIVA CLÍNICA OFICIAL ----
            Product.builder()
                .nombre("Whey Protein Isolate 100%")
                .descripcion("Aislado de proteína de suero microfiltrada. 27g de proteína y 5.8g de BCAA por servicio.")
                .precio(289000)
                .pesoKg(2.27)
                .categoria("proteinas")
                .imagenPath("assets/img/supp-whey.jpg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-WPI-2026A")
                .fechaVencimiento(LocalDate.of(2027, 8, 30))
                .registroInvima("RSA-0014523-2023")
                .stock(45)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Creatina Monohidratada Creapure®")
                .descripcion("100% monohidrato de creatina micronizada Creapure®. Máxima solubilidad y pureza probada.")
                .precio(149000)
                .pesoKg(0.5)
                .categoria("creatinas")
                .imagenPath("assets/img/supp-creatina.jpg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-CRM-2026B")
                .fechaVencimiento(LocalDate.of(2028, 1, 15))
                .registroInvima("RSA-0018902-2024")
                .stock(60)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Pre-Workout Nootrópico Focus 360")
                .descripcion("Fórmula avanzada pre-entreno con cafeína anhidra, citrulina malato y Alpha-GPC para enfoque y bombeo extremo.")
                .precio(179000)
                .pesoKg(0.38)
                .categoria("preentrenos")
                .imagenPath("assets/img/supp-preworkout.jpg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-PWO-2026C")
                .fechaVencimiento(LocalDate.of(2026, 12, 10))
                .registroInvima("RSA-0020114-2023")
                .stock(35)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("BCAA + EAA Complex Ratio 4:1:1")
                .descripcion("Aminoácidos de cadena ramificada fermentados con electrolitos marinos para recuperación intra-entreno.")
                .precio(129000)
                .pesoKg(0.42)
                .categoria("aminoacidos")
                .imagenPath("assets/img/supp-bcaa.jpg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-BCA-2026D")
                .fechaVencimiento(LocalDate.of(2027, 4, 20))
                .registroInvima("RSA-0016335-2022")
                .stock(28)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Omega 3 Alta Concentración EPA/DHA")
                .descripcion("Aceite de pescado destilado molecularmente libre de metales pesados. 800mg EPA / 400mg DHA.")
                .precio(89000)
                .pesoKg(0.2)
                .categoria("salud")
                .imagenPath("assets/img/supp-omega3.jpg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-OM3-2026E")
                .fechaVencimiento(LocalDate.of(2027, 10, 5))
                .registroInvima("RSA-0011229-2021")
                .stock(50)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Mass Gainer Premium Hyper-Caloric")
                .descripcion("Ganador de masa limpia con carbohidratos complejos de avena y amilopectina. 1.250 kcal por porción.")
                .precio(239000)
                .pesoKg(5.4)
                .categoria("proteinas")
                .imagenPath("assets/img/supp-massgainer.jpg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-MSG-2026F")
                .fechaVencimiento(LocalDate.of(2027, 3, 1))
                .registroInvima("RSA-0023441-2024")
                .stock(20)
                .disponible(true)
                .build(),

            // ---- SUPLEMENTOS ADICIONALES (Imágenes 22 a 25) ----
            Product.builder()
                .nombre("Whey Protein Isolate Vainilla Gourmet")
                .descripcion("Proteína aislada de suero 100% microfiltrada de flujo cruzado. 27g de proteína pura por servicio, cero azúcares añadidos.")
                .precio(260000)
                .pesoKg(2.0)
                .categoria("proteinas")
                .imagenPath("assets/img/prod-22.jpeg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-WHEY-2026B")
                .fechaVencimiento(LocalDate.of(2027, 8, 15))
                .registroInvima("RSA-0919281")
                .stock(35)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Creatina Monohidratada Micronizada 500g")
                .descripcion("Monohidrato de creatina de grado farmacéutico 200 mesh. Aumenta la potencia explosiva y el volumen celular.")
                .precio(140000)
                .pesoKg(0.5)
                .categoria("creatinas")
                .imagenPath("assets/img/prod-23.jpeg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-CREA-2026C")
                .fechaVencimiento(LocalDate.of(2028, 1, 18))
                .registroInvima("RSA-0203411-2023")
                .stock(42)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("BCAA Complex + Electrolitos Hydration")
                .descripcion("Matriz de aminoácidos ramificados 2:1:1 enriquecida con potasio y magnesio para hidratación y recuperación muscular continua.")
                .precio(160000)
                .pesoKg(0.5)
                .categoria("aminoacidos")
                .imagenPath("assets/img/prod-24.jpeg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-BCAA-2026D")
                .fechaVencimiento(LocalDate.of(2028, 11, 20))
                .registroInvima("RSA-0016335-2022")
                .stock(28)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Pre-Workout Nootrópico Focus & Pump")
                .descripcion("Fórmula avanzada pre-entrenamiento con beta-alanina, citrulina malato y nootrópicos para concentración mental máxima y bombeo.")
                .precio(320000)
                .pesoKg(0.6)
                .categoria("preentrenos")
                .imagenPath("assets/img/prod-25.jpeg")
                .tipo(TipoProducto.SUPLEMENTO)
                .numeroLote("LOT-PRE-2026E")
                .fechaVencimiento(LocalDate.of(2028, 10, 15))
                .registroInvima("RSA-0020114-2023")
                .stock(15)
                .disponible(true)
                .build(),

            // ---- LÍNEA OFICIAL DE ACCESORIOS DE ENTRENAMIENTO (Imágenes 26 a 41) ----
            Product.builder()
                .nombre("Cinturón de Levantamiento Profesional Cuero")
                .descripcion("Cinturón de potencia con acolchado lumbar de alta densidad y hebilla de acero de doble pasador. Soporte óptimo para sentadillas y peso muerto.")
                .precio(120000)
                .pesoKg(0.7)
                .categoria("proteccion")
                .imagenPath("assets/img/prod-26.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("100x15x1 cm")
                .stock(25)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Correas de Agarre Lifting Straps Pro")
                .descripcion("Straps de nylon de alta tenacidad con almohadilla de neopreno en muñeca. Elimina la fatiga del antebrazo en tirones pesados.")
                .precio(60000)
                .pesoKg(0.12)
                .categoria("agarre")
                .imagenPath("assets/img/prod-27.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("60x4 cm")
                .stock(30)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Muñequeras Elásticas de Soporte Heavy Duty")
                .descripcion("Par de muñequeras con banda de pulgar y velcro industrial para máxima compresión y estabilidad articular en presses.")
                .precio(45000)
                .pesoKg(0.1)
                .categoria("proteccion")
                .imagenPath("assets/img/prod-28.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("50x8 cm")
                .stock(25)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Rodilleras de Neopreno 7mm Compresión")
                .descripcion("Rodilleras anatómicas de 7mm aprobadas para powerlifting. Retienen el calor articular y potencian el rebote seguro en sentadilla.")
                .precio(90000)
                .pesoKg(0.35)
                .categoria("proteccion")
                .imagenPath("assets/img/prod-29.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("30x18 cm")
                .stock(20)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Shaker Deportivo 700ml con Bola Mezcladora")
                .descripcion("Vaso mezclador libre de BPA con tapa hermética a rosca, boquilla antifugas y resorte de acero quirúrgico para mezclas sin grumos.")
                .precio(35000)
                .pesoKg(0.18)
                .categoria("hidratacion")
                .imagenPath("assets/img/prod-30.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("9x9x24 cm")
                .stock(40)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Magnesio Deportivo en Bloque Gym Chalk")
                .descripcion("Carbonato de magnesio puro para absorción instantánea de sudor. Asegura agarre firme y seco en barra y anillas.")
                .precio(25000)
                .pesoKg(0.25)
                .categoria("agarre")
                .imagenPath("assets/img/prod-31.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("15x10x5 cm")
                .stock(50)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Fortalecedor de Agarre Hand Gripper Ajustable")
                .descripcion("Pinza con resistencia ajustable de 10 a 60 kg mediante dial giratorio. Mango ergonómico de goma antideslizante.")
                .precio(35000)
                .pesoKg(0.3)
                .categoria("agarre")
                .imagenPath("assets/img/prod-32.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("16x11 cm")
                .stock(35)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Tobilleras Acolchadas para Polea (Par)")
                .descripcion("Correas de tobillo con forro de neopreno y argollas D soldadas en acero. Diseñadas para patadas de glúteo y abductores.")
                .precio(40000)
                .pesoKg(0.25)
                .categoria("funcional")
                .imagenPath("assets/img/prod-33.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("25x10 cm")
                .stock(30)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Barra Recta Giratoria para Polea")
                .descripcion("Barra de acero macizo cromado con moleteado diamante y articulación giratoria central fluida para jalones y bíceps.")
                .precio(75000)
                .pesoKg(2.5)
                .categoria("funcional")
                .imagenPath("assets/img/prod-34.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("50x3 cm")
                .stock(18)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Rodillo de Liberación Miofascial Foam Roller")
                .descripcion("Rodillo de masaje muscular con relieve 3D de alta densidad para activación pre-entreno y recuperación del tejido fascial.")
                .precio(55000)
                .pesoKg(0.8)
                .categoria("recuperacion")
                .imagenPath("assets/img/prod-35.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("45x14 cm")
                .stock(22)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Seguros de Bloqueo Rápido para Barra Olímpica")
                .descripcion("Collares tipo Lock-Jaw con leva de presión para barras olímpicas de 50mm. Fijan los discos con seguridad total.")
                .precio(30000)
                .pesoKg(0.35)
                .categoria("pesas")
                .imagenPath("assets/img/prod-36.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("8x8 cm")
                .stock(45)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Set de Bandas Elásticas de Resistencia Loop")
                .descripcion("Juego de 5 bandas de látex 100% natural con diferentes niveles de tensión progresiva para calentamiento y glúteos.")
                .precio(45000)
                .pesoKg(0.4)
                .categoria("funcional")
                .imagenPath("assets/img/prod-37.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("30x5 cm")
                .stock(35)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Cinturón para Fondos y Dominadas Lastradas (Dip Belt)")
                .descripcion("Arnés lumbar reforzado con cadena de acero y mosquetones de seguridad para sobrecarga progresiva con discos.")
                .precio(85000)
                .pesoKg(1.2)
                .categoria("fuerza")
                .imagenPath("assets/img/prod-38.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("85x16 cm")
                .stock(15)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Báscula Digital Corporal de Bioimpedancia")
                .descripcion("Báscula inteligente con sensores de alta precisión para registro de peso corporal, porcentaje de grasa y masa magra.")
                .precio(65000)
                .pesoKg(1.5)
                .categoria("medicion")
                .imagenPath("assets/img/prod-39.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("30x30x2 cm")
                .stock(20)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Bolso Deportivo Gym Duffel Bag Resistente")
                .descripcion("Maletín deportivo impermeable con compartimento ventilado para calzado, bolsillo para shaker y correa acolchada.")
                .precio(120000)
                .pesoKg(0.9)
                .categoria("transporte")
                .imagenPath("assets/img/prod-40.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("55x30x30 cm")
                .stock(18)
                .disponible(true)
                .build(),

            Product.builder()
                .nombre("Colchoneta de Entrenamiento Profesional 15mm")
                .descripcion("Mat de espuma NBR de alta densidad con superficie antideslizante y correa de transporte. Absorción óptima de impactos.")
                .precio(180000)
                .pesoKg(2.2)
                .categoria("funcional")
                .imagenPath("assets/img/prod-41.jpeg")
                .tipo(TipoProducto.ACCESORIO)
                .dimensiones("180x60x1.5 cm")
                .stock(15)
                .disponible(true)
                .build()
        );

        List<Product> guardados = productRepository.saveAll(productos);

        // Lotes de control sanitario para suplementos
        guardados.stream()
            .filter(p -> p.getTipo() == TipoProducto.SUPLEMENTO)
            .forEach(p -> {
                SupplementBatch batch = SupplementBatch.builder()
                    .productoId(p.getId())
                    .productoNombre(p.getNombre())
                    .numeroLote(p.getNumeroLote())
                    .fechaFabricacion(LocalDate.now().minusMonths(6))
                    .fechaVencimiento(p.getFechaVencimiento())
                    .cantidadStock(p.getStock())
                    .laboratorio("Kinex Pharma Lab")
                    .registroInvima(p.getRegistroInvima())
                    .build();
                supplementBatchRepository.save(batch);
            });
    }

    private void inicializarUsuarios() {
        User admin = User.builder()
            .nombre("Admin")
            .apellido("KinexStore")
            .email("admin@kinexstore.co")
            .passwordHash(passwordEncoder.encode("admin"))
            .telefono("+57 300 123 4567")
            .direccion("Edificio Kinex Corporate, Piso 12")
            .pais("Colombia")
            .estadoProvincia("Antioquia")
            .ciudad("Medellín")
            .codigoPostal("050021")
            .direccionDetallada("Carrera 43A # 1-50, El Poblado")
            .rol(Rol.ADMINISTRADOR)
            .activo(true)
            .build();

        User cliente = User.builder()
            .nombre("Carlos")
            .apellido("Gómez")
            .email("carlos.gomez@gmail.com")
            .passwordHash(passwordEncoder.encode("cliente"))
            .telefono("+57 312 987 6543")
            .direccion("Calle 85 # 11-53, Chapinero")
            .pais("Colombia")
            .estadoProvincia("Bogotá D.C.")
            .ciudad("Bogotá")
            .codigoPostal("110221")
            .direccionDetallada("Calle 85 # 11-53, Apto 402, Chapinero")
            .rol(Rol.CLIENTE)
            .activo(true)
            .build();

        userRepository.saveAll(List.of(admin, cliente));
    }

    private void inicializarPromociones() {
        Promotion promo1 = Promotion.builder()
            .codigo("KINEX10")
            .titulo("10% OFF en toda la tienda")
            .subtitulo("Aplica para compras superiores a $ 500.000 COP")
            .porcentajeDescuento(10.0)
            .compraMinimaCOP(500000.0)
            .fechaInicio(LocalDate.now())
            .fechaFin(LocalDate.now().plusMonths(6))
            .usosRestantes(500)
            .ctaTexto("Aprovechar Descuento")
            .ctaUrl("/catalogo/equipamiento")
            .tipo(TipoPromo.CUPON)
            .activa(true)
            .build();

        Promotion promo2 = Promotion.builder()
            .codigo("BLACKGYM")
            .titulo("Equipa tu Gym — Flete Especial")
            .subtitulo("15% OFF en maquinaria pesada seleccionada")
            .porcentajeDescuento(15.0)
            .compraMinimaCOP(2000000.0)
            .fechaInicio(LocalDate.now())
            .fechaFin(LocalDate.now().plusMonths(3))
            .usosRestantes(100)
            .ctaTexto("Ver Maquinaria")
            .ctaUrl("/catalogo/equipamiento")
            .tipo(TipoPromo.CUPON)
            .activa(true)
            .build();

        promotionRepository.saveAll(List.of(promo1, promo2));
    }
}
