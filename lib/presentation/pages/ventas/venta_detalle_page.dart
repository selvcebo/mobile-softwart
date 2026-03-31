import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/venta.dart';
import '../../providers/ventas_provider.dart';
import '../../widgets/loading_widget.dart';

class VentaDetallePage extends StatefulWidget {
  final Venta venta;

  const VentaDetallePage({super.key, required this.venta});

  @override
  State<VentaDetallePage> createState() => _VentaDetallePageState();
}

class _VentaDetallePageState extends State<VentaDetallePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<VentasProvider>()
          .cargarEstadoPagos(widget.venta.idVenta);
    });
  }

  String _formatNum(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    final venta = widget.venta;
    return Scaffold(
      appBar: AppBar(title: Text('Venta #${venta.idVenta}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      label: 'Cliente',
                      valor: venta.nombreCliente ?? '—',
                    ),
                    _InfoRow(label: 'Fecha', valor: formatFecha(venta.fecha)),
                    _InfoRow(
                      label: 'Total',
                      valor: '\$${_formatNum(venta.total)}',
                    ),
                    _InfoRow(
                      label: 'Estado',
                      valor:
                          venta.estado ? 'Pagada' : 'Pendiente de pago',
                    ),
                    _InfoRow(
                      label: 'Abonos',
                      valor: '${venta.numAbonos}',
                    ),
                    _InfoRow(
                      label: 'Primer abono',
                      valor: '${venta.porcentajePrimerAbono}%',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Estado de pagos',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Consumer<VentasProvider>(
              builder: (context, provider, _) {
                if (provider.isLoadingPagos) {
                  return const LoadingWidget();
                }
                final pagos = provider.estadoPagos;
                if (pagos == null) {
                  return const Text('Sin información de pagos');
                }
                final abonos = pagos['plan_abonos'] as List<dynamic>? ?? [];
                final pagosRealizados = pagos['pagos_realizados'] as int? ?? 0;
                final totalPagado =
                    (pagos['total_pagado'] as num?)?.toDouble() ?? 0;
                final saldoPendiente =
                    (pagos['saldo_pendiente'] as num?)?.toDouble() ?? 0;
                return Column(
                  children: [
                    ...abonos.asMap().entries.map((entry) {
                      final index = entry.key;
                      final abono = entry.value as Map<String, dynamic>;
                      final pagado = index < pagosRealizados;
                      final monto =
                          (abono['montoEsperado'] as num?)?.toDouble() ?? 0;
                      final numero = abono['numero'] as int? ?? (index + 1);
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            pagado
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: pagado
                                ? const Color(0xFF10B981)
                                : AppColors.muted,
                          ),
                          title: Text('Abono #$numero'),
                          subtitle:
                              Text(pagado ? 'Pagado' : 'Pendiente'),
                          trailing: Text(
                            '\$${_formatNum(monto)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    Card(
                      color: AppColors.primary.withOpacity(0.05),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pagado',
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '\$${_formatNum(totalPagado)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Pendiente',
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '\$${_formatNum(saldoPendiente)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: saldoPendiente > 0
                                        ? const Color(0xFFF59E0B)
                                        : AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String valor;

  const _InfoRow({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
