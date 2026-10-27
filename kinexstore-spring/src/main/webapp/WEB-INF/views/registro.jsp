<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Crear Cuenta y Envío" />
<c:set var="pageDescription" value="Crea tu cuenta de cliente en KinexStore para gestionar tus envíos y finalizar tus compras." />
<%@ include file="includes/header.jsp" %>

    <div class="max-w-xl mx-auto px-margin-mobile py-12" id="section-registro">
        
        <!-- Header del Formulario -->
        <div class="text-center mb-8">
            <span class="material-symbols-outlined text-4xl text-primary-fixed mb-2 block">person_add</span>
            <h1 class="font-headline-lg text-primary mb-2">Crear Cuenta</h1>
            <p class="font-body-md text-on-surface-variant">Completa tus datos personales y de envío para tu compra en KinexStore</p>
        </div>

        <!-- Banner contextual si proviene de Checkout -->
        <c:if test="${param.from == 'checkout' or sessionScope.redirectUrlPostAuth == '/checkout'}">
            <div class="mb-6 p-4 bg-primary-fixed/10 border border-primary-fixed rounded flex items-center gap-3 text-primary-fixed font-label-md text-sm">
                <span class="material-symbols-outlined text-xl flex-shrink-0">shopping_cart_checkout</span>
                <div>
                    <strong>Paso previo al Checkout:</strong> Crea tu cuenta de envío para guardar los productos de tu carrito y calcular el flete exacto de forma segura.
                </div>
            </div>
        </c:if>

        <!-- Mensajes de Error de Validación -->
        <c:if test="${not empty errorRegistro}">
            <div class="mb-6 p-4 bg-error-container/20 border border-rogue-red rounded text-rogue-red font-label-md text-sm flex items-center gap-2" role="alert">
                <span class="material-symbols-outlined text-base">error</span>
                <span>${errorRegistro}</span>
            </div>
        </c:if>

        <c:if test="${not empty erroresValidacion}">
            <div class="mb-6 p-4 bg-error-container/20 border border-rogue-red rounded text-rogue-red font-label-md text-sm" role="alert">
                <div class="font-bold mb-1 flex items-center gap-2">
                    <span class="material-symbols-outlined text-base">warning</span>
                    Por favor corrige los siguientes campos:
                </div>
                <ul class="list-disc list-inside space-y-1 text-xs">
                    <c:forEach items="${erroresValidacion}" var="err">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <form action="${contextPath}/registro" method="post" id="registro-form"
              class="bg-surface-charcoal border border-border-industrial rounded-DEFAULT p-8 space-y-6">

            <!-- SECCIÓN 1: DATOS PERSONALES -->
            <div>
                <h3 class="font-label-md text-primary font-bold text-sm uppercase tracking-wider mb-3 flex items-center gap-2 text-primary-fixed">
                    <span class="material-symbols-outlined text-base">badge</span> Datos Personales
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="reg-nombre" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                            Nombre <span class="text-primary-fixed">*</span>
                        </label>
                        <input type="text" name="nombre" id="reg-nombre"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                      focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                               placeholder="Juan" required value="${dto != null ? dto.nombre : param.nombre}">
                    </div>
                    <div>
                        <label for="reg-apellido" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                            Apellido <span class="text-primary-fixed">*</span>
                        </label>
                        <input type="text" name="apellido" id="reg-apellido"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                      focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                               placeholder="Pérez" required value="${dto != null ? dto.apellido : param.apellido}">
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 2: SEGURIDAD Y ACCESO -->
            <div>
                <h3 class="font-label-md text-primary font-bold text-sm uppercase tracking-wider mb-3 flex items-center gap-2 text-primary-fixed">
                    <span class="material-symbols-outlined text-base">lock</span> Acceso y Seguridad
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="reg-email" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                            Correo Electrónico <span class="text-primary-fixed">*</span>
                        </label>
                        <input type="email" name="email" id="reg-email"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                      focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                               placeholder="tu@correo.com" required autocomplete="email" value="${dto != null ? dto.email : param.email}">
                    </div>
                    <div>
                        <label for="reg-telefono" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                            Teléfono de Contacto <span class="text-primary-fixed">*</span>
                        </label>
                        <input type="tel" name="telefono" id="reg-telefono"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                      focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                               placeholder="+57 300 123 4567" required value="${dto != null ? dto.telefono : param.telefono}">
                    </div>
                </div>

                <div class="mt-4">
                    <label for="reg-password" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                        Contraseña <span class="text-primary-fixed">*</span>
                    </label>
                    <input type="password" name="password" id="reg-password"
                           class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                  focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                           placeholder="Mín. 8 caracteres, 1 mayúscula y 1 número" required autocomplete="new-password">
                    <p class="text-[11px] text-text-muted mt-1 font-mono">
                        🔒 Debe contener al menos 8 caracteres, una letra mayúscula y un número.
                    </p>
                </div>
            </div>

            <!-- SECCIÓN 3: DIRECCIÓN DE ENVÍO -->
            <div>
                <h3 class="font-label-md text-primary font-bold text-sm uppercase tracking-wider mb-3 flex items-center gap-2 text-primary-fixed">
                    <span class="material-symbols-outlined text-base">local_shipping</span> Dirección de Envío y Flete
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label for="reg-pais" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                            País <span class="text-primary-fixed">*</span>
                        </label>
                        <select name="pais" id="reg-pais"
                                class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                       focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all">
                            <option value="Colombia" selected>Colombia</option>
                            <option value="México">México</option>
                            <option value="Estados Unidos">Estados Unidos</option>
                            <option value="Chile">Chile</option>
                            <option value="Perú">Perú</option>
                        </select>
                    </div>
                    <div>
                        <label for="reg-estadoProvincia" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                            Departamento / Estado <span class="text-primary-fixed">*</span>
                        </label>
                        <input type="text" name="estadoProvincia" id="reg-estadoProvincia"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                      focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                               placeholder="Ej: Antioquia o Cundinamarca" required value="${dto != null ? dto.estadoProvincia : (not empty param.estadoProvincia ? param.estadoProvincia : 'Antioquia')}">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label for="reg-ciudad" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                            Ciudad <span class="text-primary-fixed">*</span>
                        </label>
                        <input type="text" name="ciudad" id="reg-ciudad"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                      focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                               placeholder="Ej: Medellín o Bogotá" required value="${dto != null ? dto.ciudad : (not empty param.ciudad ? param.ciudad : 'Medellín')}">
                    </div>
                    <div>
                        <label for="reg-codigoPostal" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                            Código Postal <span class="text-primary-fixed">*</span>
                        </label>
                        <input type="text" name="codigoPostal" id="reg-codigoPostal"
                               class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                      focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                               placeholder="050021" required value="${dto != null ? dto.codigoPostal : (not empty param.codigoPostal ? param.codigoPostal : '050021')}">
                    </div>
                </div>

                <div>
                    <label for="reg-direccionDetallada" class="font-label-md text-on-surface-variant block mb-1 text-xs">
                        Dirección Detallada (Calle, Número, Apto, Edificio) <span class="text-primary-fixed">*</span>
                    </label>
                    <input type="text" name="direccionDetallada" id="reg-direccionDetallada"
                           class="w-full bg-[#0A0A0A] border border-border-industrial text-primary font-body-md rounded p-3 text-sm
                                  focus:ring-2 focus:ring-primary-fixed focus:border-primary-fixed transition-all"
                           placeholder="Ej: Carrera 43A # 1-50, Apto 402, Torre 2" required value="${dto != null ? dto.direccionDetallada : param.direccionDetallada}">
                </div>
            </div>

            <!-- BOTÓN DE ENVÍO -->
            <button type="submit"
                    class="w-full bg-primary-fixed text-black font-label-md px-8 py-4 rounded-DEFAULT
                           hover:bg-white hover:shadow-lg hover:shadow-primary-fixed/50
                           transition-all duration-200 uppercase font-bold tracking-wider text-sm mt-6"
                    id="btn-registro">
                Completar Registro y Continuar
            </button>

            <p class="text-center font-label-sm text-on-surface-variant pt-2 text-xs">
                ¿Ya tienes una cuenta registrada?
                <a href="${contextPath}/login"
                   class="text-primary-fixed hover:underline font-bold" id="link-login">Inicia sesión aquí</a>
            </p>
        </form>
    </div>

<%@ include file="includes/footer.jsp" %>
