import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/user_menu_button.dart';
import '../main_shell.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().cargar();
    });
  }

  String _formatCOP(dynamic value) {
    final v = value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '0') ?? 0.0;
    final formatted = v
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '\$$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => MainShell.scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Dashboard'),
        actions: [
          Consumer<DashboardProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: provider.isLoading ? null : () => provider.cargar(),
              tooltip: 'Actualizar',
            ),
          ),
          const UserMenuButton(),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingWidget(mensaje: 'Cargando estadísticas...');
          }
          if (provider.error != null) {
            return AppErrorWidget(
              mensaje: provider.error!,
              onRetry: () => provider.cargar(),
            );
          }
          final stats = provider.stats;
          if (stats == null) {
            return const Center(child: Text('Sin datos'));
          }
          return RefreshIndicator(
            onRefresh: () => provider.cargar(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado
                  const Text(
                    'Resumen del negocio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Datos en tiempo real',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // KPI cards 2x2
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      KpiCard(
                        titulo: 'Ventas del mes',
                        valor: _formatCOP(stats.totalVentasMes),
                        icono: Icons.receipt_long_outlined,
                        colorIcono: AppColors.primary,
                      ),
                      KpiCard(
                        titulo: 'Citas hoy',
                        valor: '${stats.citasHoy}',
                        icono: Icons.event_outlined,
                        colorIcono: AppColors.secondary,
                      ),
                      KpiCard(
                        titulo: 'Servicios activos',
                        valor: '${stats.pedidosPendientes}',
                        icono: Icons.inventory_2_outlined,
                        colorIcono: AppColors.warning,
                      ),
                      KpiCard(
                        titulo: 'Pagos pendientes',
                        valor: _formatCOP(stats.pagosPendientes),
                        icono: Icons.payments_outlined,
                        colorIcono: AppColors.destructive,
                      ),
                    ]
                  ),
                  const SizedBox(height: 12),

                  // Citas del día
                  if (stats.citasHoyLista.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Citas de hoy',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...stats.citasHoyLista.map((c) => _CitaHoyTile(cita: c)),
                  ],

                  // Ventas recientes
                  if (stats.ventasRecientes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Ventas recientes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...stats.ventasRecientes.map(
                      (v) => _VentaRecienteTile(venta: v, formatCOP: _formatCOP),
                    ),
                  ],

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CitaHoyTile extends StatelessWidget {
  final Map<String, dynamic> cita;
  const _CitaHoyTile({required this.cita});

  @override
  Widget build(BuildContext context) {
    final hora = cita['hora'] as String? ?? '';
    final cliente = cita['cliente_nombre'] as String? ?? 'Cliente';
    final estado = cita['estado'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.schedule_rounded,
            color: AppColors.secondary,
            size: 18,
          ),
        ),
        title: Text(
          cliente,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(formatHora(hora), style: const TextStyle(fontSize: 12)),
        trailing: estado.isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  estado,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _VentaRecienteTile extends StatelessWidget {
  final Map<String, dynamic> venta;
  final String Function(dynamic) formatCOP;
  const _VentaRecienteTile({required this.venta, required this.formatCOP});

  @override
  Widget build(BuildContext context) {
    final cliente = venta['cliente_nombre'] as String? ?? 'Cliente';
    final total = venta['total'];
    final fecha = venta['fecha'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.receipt_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        title: Text(
          cliente,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(formatFecha(fecha), style: const TextStyle(fontSize: 12)),
        trailing: Text(
          formatCOP(total),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
