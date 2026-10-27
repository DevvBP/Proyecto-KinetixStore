<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Dashboard Ejecutivo" />
<%@ include file="includes/admin_header.jsp" %>

<!-- Header de Sección -->
<div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
    <div>
        <h1 class="font-display font-bold text-2xl lg:text-3xl text-white">Dashboard Ejecutivo</h1>
        <p class="font-mono text-xs text-text-muted mt-1">Métricas clave de rendimiento, ventas y estado de inventario.</p>
    </div>
    <div class="flex items-center gap-3">
        <span class="font-mono text-xs text-primary-fixed bg-surface-card px-3 py-1.5 rounded border border-border-industrial">
            ● Periodo: Septiembre 2026
        </span>
    </div>
</div>

<!-- Grid de 4 KPIs Principales -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">

    <!-- KPI 1: Ventas del Mes -->
    <div class="bg-surface-charcoal border border-border-industrial rounded p-5 hover:border-primary-fixed transition-all duration-200 group">
        <div class="flex items-center justify-between text-text-muted mb-3">
            <span class="font-mono text-xs uppercase tracking-wider font-semibold">Ventas del Mes</span>
            <span class="material-symbols-outlined text-primary-fixed group-hover:scale-110 transition-transform">monetization_on</span>
        </div>
        <div class="font-mono text-2xl font-bold text-white tracking-tight">
            ${metricas.ventasMesFormateado}
        </div>
        <div class="flex items-center gap-1.5 mt-2 font-mono text-[11px] text-primary-fixed">
            <span class="material-symbols-outlined text-sm">trending_up</span>
            <span>+18.4% vs mes anterior</span>
        </div>
    </div>

    <!-- KPI 2: Pedidos Pendientes -->
    <div class="bg-surface-charcoal border border-border-industrial rounded p-5 hover:border-primary-fixed transition-all duration-200 group">
        <div class="flex items-center justify-between text-text-muted mb-3">
            <span class="font-mono text-xs uppercase tracking-wider font-semibold">Pedidos Pendientes</span>
            <span class="material-symbols-outlined text-secondary group-hover:scale-110 transition-transform">pending_actions</span>
        </div>
        <div class="font-mono text-2xl font-bold text-white tracking-tight">
            ${metricas.pedidosPendientes} órdenes
        </div>
        <div class="flex items-center gap-1.5 mt-2 font-mono text-[11px] text-text-muted">
            <span>Requieren empaque/despacho</span>
        </div>
    </div>

    <!-- KPI 3: Alertas Stock Bajo -->
    <div class="bg-surface-charcoal border border-border-industrial rounded p-5 hover:border-rogue-red transition-all duration-200 group">
        <div class="flex items-center justify-between text-text-muted mb-3">
            <span class="font-mono text-xs uppercase tracking-wider font-semibold">Alertas de Stock</span>
            <span class="material-symbols-outlined text-rogue-red group-hover:scale-110 transition-transform">warning</span>
        </div>
        <div class="font-mono text-2xl font-bold text-white tracking-tight">
            ${metricas.alertasStockBajo} ítems
        </div>
        <div class="flex items-center gap-1.5 mt-2 font-mono text-[11px] text-rogue-red">
            <span>≤ 5 unidades disponibles</span>
        </div>
    </div>

    <!-- KPI 4: Clientes Registrados -->
    <div class="bg-surface-charcoal border border-border-industrial rounded p-5 hover:border-primary-fixed transition-all duration-200 group">
        <div class="flex items-center justify-between text-text-muted mb-3">
            <span class="font-mono text-xs uppercase tracking-wider font-semibold">Comunidad Atletas</span>
            <span class="material-symbols-outlined text-primary-fixed group-hover:scale-110 transition-transform">group</span>
        </div>
        <div class="font-mono text-2xl font-bold text-white tracking-tight">
            ${metricas.totalClientes} clientes
        </div>
        <div class="flex items-center gap-1.5 mt-2 font-mono text-[11px] text-primary-fixed">
            <span>+12 nuevos esta semana</span>
        </div>
    </div>

</div>

<!-- Gráficos & Resumen de Órdenes Recientes -->
<div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">

    <!-- Gráfico / Proyección de Ventas (2 columnas) -->
    <div class="lg:col-span-2 bg-surface-charcoal border border-border-industrial rounded p-6">
        <div class="flex items-center justify-between mb-6">
            <h2 class="font-display font-semibold text-lg text-white">Comportamiento Semanal de Ingresos</h2>
            <span class="font-mono text-xs text-text-muted">Cifras en Millones COP</span>
        </div>

        <!-- Barras de Gráfico Visual en CSS/HTML -->
        <div class="space-y-4 font-mono text-xs">
            <div>
                <div class="flex justify-between mb-1 text-text-muted">
                    <span>Semana 1 (Maquinaria Pesada)</span>
                    <span class="text-white font-bold">$ 18.2M</span>
                </div>
                <div class="w-full bg-[#131313] h-3 rounded overflow-hidden">
                    <div class="bg-primary-fixed h-full rounded" style="width: 75%;"></div>
                </div>
            </div>

            <div>
                <div class="flex justify-between mb-1 text-text-muted">
                    <span>Semana 2 (Suplementación Élite)</span>
                    <span class="text-white font-bold">$ 12.8M</span>
                </div>
                <div class="w-full bg-[#131313] h-3 rounded overflow-hidden">
                    <div class="bg-primary-fixed/80 h-full rounded" style="width: 55%;"></div>
                </div>
            </div>

            <div>
                <div class="flex justify-between mb-1 text-text-muted">
                    <span>Semana 3 (Equipamiento Comercial + Mayoristas)</span>
                    <span class="text-white font-bold">$ 24.5M</span>
                </div>
                <div class="w-full bg-[#131313] h-3 rounded overflow-hidden">
                    <div class="bg-primary-fixed h-full rounded" style="width: 95%;"></div>
                </div>
            </div>

            <div>
                <div class="flex justify-between mb-1 text-text-muted">
                    <span>Semana 4 (Planes &amp; Reordenes)</span>
                    <span class="text-white font-bold">$ 15.1M</span>
                </div>
                <div class="w-full bg-[#131313] h-3 rounded overflow-hidden">
                    <div class="bg-primary-fixed/70 h-full rounded" style="width: 62%;"></div>
                </div>
            </div>
        </div>

        <div class="mt-6 pt-4 border-t border-border-industrial flex flex-wrap items-center justify-between text-xs font-mono text-text-muted gap-2">
            <span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 bg-primary-fixed rounded-full"></span> Maquinaria: 68%</span>
            <span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 bg-secondary rounded-full"></span> Suplementación: 24%</span>
            <span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 bg-outline rounded-full"></span> Planes Personalizados: 8%</span>
        </div>
    </div>

    <!-- Alertas de Stock Crítico -->
    <div class="bg-surface-charcoal border border-border-industrial rounded p-6 flex flex-col justify-between">
        <div>
            <div class="flex items-center justify-between mb-4">
                <h2 class="font-display font-semibold text-lg text-white">Stock Crítico</h2>
                <a href="${contextPath}/admin?accion=gestionarSuplementos" class="font-mono text-xs text-primary-fixed hover:underline">Ver todos</a>
            </div>
            <p class="font-mono text-xs text-text-muted mb-4">Productos que requieren reposición urgente con proveedores:</p>

            <div class="space-y-3">
                <c:forEach items="${metricas.productosBajoStock}" var="p">
                    <div class="bg-[#131313] border border-border-industrial rounded p-3 flex items-center justify-between">
                        <div>
                            <p class="font-mono text-xs text-white font-semibold">${p.nombre}</p>
                            <p class="font-mono text-[11px] text-text-muted">Categoría: ${p.categoria}</p>
                        </div>
                        <span class="bg-rogue-red/20 text-rogue-red border border-rogue-red font-mono text-xs px-2 py-1 rounded font-bold">
                            ${p.stock} un.
                        </span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="mt-4 pt-4 border-t border-border-industrial">
            <a href="${contextPath}/admin?accion=gestionarMaquinas"
               class="w-full bg-[#131313] border border-border-industrial hover:border-primary-fixed hover:text-primary-fixed text-text-muted font-mono text-xs py-2 px-4 rounded flex items-center justify-center gap-2 transition-all">
                <span class="material-symbols-outlined text-sm">add_box</span>
                <span>Ingresar Nuevo Lote</span>
            </a>
        </div>
    </div>

</div>

<!-- Tabla de Últimos Pedidos Recibidos -->
<div class="bg-surface-charcoal border border-border-industrial rounded p-6">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
        <div>
            <h2 class="font-display font-semibold text-lg text-white">Últimos Pedidos Registrados</h2>
            <p class="font-mono text-xs text-text-muted">Órdenes de compra generadas en la plataforma.</p>
        </div>
        <a href="${contextPath}/admin?accion=gestionarPedidos"
           class="font-mono text-xs text-primary-fixed hover:underline flex items-center gap-1">
            <span>Bandeja de Logística Completa</span>
            <span class="material-symbols-outlined text-sm">arrow_forward</span>
        </a>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full text-left font-mono text-xs">
            <thead>
                <tr class="border-b border-border-industrial text-text-muted uppercase text-[10px] tracking-wider">
                    <th class="py-3 px-4">Orden</th>
                    <th class="py-3 px-4">Cliente</th>
                    <th class="py-3 px-4">Ciudad</th>
                    <th class="py-3 px-4">Tipo Carga</th>
                    <th class="py-3 px-4">Total COP</th>
                    <th class="py-3 px-4">Estado</th>
                    <th class="py-3 px-4 text-right">Acción</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-border-industrial">
                <c:forEach items="${metricas.ultimosPedidos}" var="ord">
                    <tr class="hover:bg-surface-hover transition-colors">
                        <td class="py-3.5 px-4 font-bold text-white">${ord.numeroOrden}</td>
                        <td class="py-3.5 px-4 text-on-surface">
                            <div>${ord.clienteNombre}</div>
                            <div class="text-[10px] text-text-muted">${ord.clienteEmail}</div>
                        </td>
                        <td class="py-3.5 px-4 text-text-muted">${ord.ciudad}</td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${ord.esCargaPesada}">
                                    <span class="bg-primary-fixed/10 border border-primary-fixed text-primary-fixed text-[10px] px-2 py-0.5 rounded font-semibold">
                                        🚜 Pesada
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bg-surface-card border border-border-industrial text-text-muted text-[10px] px-2 py-0.5 rounded">
                                        📦 Estándar
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-primary-fixed font-bold">${ord.totalFormateado}</td>
                        <td class="py-3.5 px-4">
                            <c:choose>
                                <c:when test="${ord.estado == 'PENDIENTE'}">
                                    <span class="bg-secondary/20 text-secondary border border-secondary/40 text-[10px] px-2 py-0.5 rounded font-semibold">Pendiente</span>
                                </c:when>
                                <c:when test="${ord.estado == 'EMPACADO'}">
                                    <span class="bg-primary-fixed/20 text-primary-fixed border border-primary-fixed/40 text-[10px] px-2 py-0.5 rounded font-semibold">Empacado</span>
                                </c:when>
                                <c:when test="${ord.estado == 'EN_TRANSITO'}">
                                    <span class="bg-sky-500/20 text-sky-400 border border-sky-500/40 text-[10px] px-2 py-0.5 rounded font-semibold">En Tránsito</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="bg-emerald-500/20 text-emerald-400 border border-emerald-500/40 text-[10px] px-2 py-0.5 rounded font-semibold">Entregado</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="py-3.5 px-4 text-right">
                            <a href="${contextPath}/admin?accion=gestionarPedidos"
                               class="text-text-muted hover:text-primary-fixed p-1 rounded hover:bg-[#131313] transition-colors"
                               title="Ver en Logística">
                                <span class="material-symbols-outlined text-sm">visibility</span>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="includes/admin_footer.jsp" %>
