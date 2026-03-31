import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/pedido.dart';
import '../../providers/pedidos_provider.dart';
import '../../widgets/estado_badge.dart';

class PedidoDetallePage extends StatefulWidget {
  final Pedido pedido;

  const PedidoDetallePage({super.key, required this.pedido});

  @override
  State<PedidoDetallePage> createState() => _PedidoDetallePageState();
}

class _PedidoDetallePageState extends State<PedidoDetallePage> {
  static const _estados = [
    (id: 1, nombre: 'Sin empezar'),
    (id: 2, nombre: 'En preparación'),
    (id: 3, nombre: 'Finalizado'),
  ];

  int? _estadoSeleccionado;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _estadoSeleccionado = widget.pedido.idEstado;
  }

  Future<void> _guardar() async {
    if (_estadoSeleccionado == null ||
        _estadoSeleccionado == widget.pedido.idEstado) return;

    setState(() => _guardando = true);
    final ok = await context
        .read<PedidosProvider>()
        .cambiarEstado(widget.pedido.idDetalle, _estadoSeleccionado!);
    if (!mounted) return;
    setState(() => _guardando = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estado actualizado'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<PedidosProvider>().error ?? 'Error al actualizar',
          ),
          backgroundColor: AppColors.destructive,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedido = widget.pedido;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de servicio')),
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
                      label: 'Servicio',
                      valor: pedido.nombreServicio ?? '—',
                    ),
                    _InfoRow(label: 'Venta', valor: '#${pedido.idVenta}'),
                    _InfoRow(
                      label: 'Precio',
                      valor: '\$${_formatNum(pedido.precio)}',
                    ),
                    if (pedido.descripcion != null &&
                        pedido.descripcion!.isNotEmpty)
                      _InfoRow(
                        label: 'Descripción',
                        valor: pedido.descripcion!,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Estado: ',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                          ),
                        ),
                        EstadoBadge(texto: pedido.estado),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Cambiar estado',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _estados.map((e) {
                final selected = _estadoSeleccionado == e.id;
                return GestureDetector(
                  onTap: () => setState(() => _estadoSeleccionado = e.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                        width: selected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      e.nombre,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        color: selected ? Colors.white : AppColors.foreground,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar cambio'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNum(double value) => value
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
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
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
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
