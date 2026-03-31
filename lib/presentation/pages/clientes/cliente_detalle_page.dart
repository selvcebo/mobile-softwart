import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/cita.dart';
import '../../../domain/entities/cliente.dart';
import '../../../domain/entities/pedido.dart';
import '../../providers/citas_provider.dart';
import '../../providers/pedidos_provider.dart';
import '../../providers/ventas_provider.dart';
import '../../widgets/estado_badge.dart';

class ClienteDetallePage extends StatefulWidget {
  final Cliente cliente;

  const ClienteDetallePage({super.key, required this.cliente});

  @override
  State<ClienteDetallePage> createState() => _ClienteDetallePageState();
}

class _ClienteDetallePageState extends State<ClienteDetallePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar los providers que aún no tengan datos
      final cp = context.read<CitasProvider>();
      if (cp.citas.isEmpty && !cp.isLoading) cp.cargar();

      final vp = context.read<VentasProvider>();
      if (vp.ventas.isEmpty && !vp.isLoading) vp.cargar();

      final pp = context.read<PedidosProvider>();
      if (pp.pedidos.isEmpty && !pp.isLoading) pp.cargar();
    });
  }

  /// Citas que pertenecen a este cliente (match por correo o nombre)
  List<Cita> _citasCliente(List<Cita> todas) {
    return todas.where((c) {
      if (c.correoCliente != null && c.correoCliente!.isNotEmpty) {
        return c.correoCliente!.toLowerCase() ==
            widget.cliente.correo.toLowerCase();
      }
      return (c.nombreCliente ?? '').toLowerCase() ==
          widget.cliente.nombre.toLowerCase();
    }).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  /// Pedidos del cliente: via ventas → idVenta de pedidos
  List<Pedido> _pedidosCliente(
    List<Pedido> todosPedidos,
    Set<int> ventaIds,
  ) {
    return todosPedidos
        .where((p) => ventaIds.contains(p.idVenta))
        .toList()
      ..sort((a, b) => a.idDetalle.compareTo(b.idDetalle));
  }

  String _formatHora(String hora) {
    if (!hora.contains(':')) return hora;
    final p = hora.split(':');
    final h = int.tryParse(p[0]) ?? 0;
    final m = p.length > 1 ? p[1] : '00';
    return '${h == 0 ? 12 : (h > 12 ? h - 12 : h)}:$m ${h >= 12 ? 'PM' : 'AM'}';
  }

  String _formatCOP(double v) {
    final s = v
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '\$$s';
  }

  @override
  Widget build(BuildContext context) {
    final cliente = widget.cliente;

    return Scaffold(
      appBar: AppBar(title: Text(cliente.nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar y estado ──────────────────────────────────────
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.4),
                    child: Text(
                      cliente.nombre[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cliente.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cliente.activo
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.muted.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cliente.activo ? 'Activo' : 'Inactivo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cliente.activo
                            ? AppColors.success
                            : AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Información de contacto ───────────────────────────────
            _SectionCard(
              titulo: 'Información de contacto',
              icono: Icons.person_outline_rounded,
              children: [
                _InfoRow(label: 'Correo', valor: cliente.correo),
                if (cliente.telefono != null)
                  _InfoRow(label: 'Teléfono', valor: cliente.telefono!),
                if (cliente.direccion != null)
                  _InfoRow(label: 'Dirección', valor: cliente.direccion!),
              ],
            ),
            const SizedBox(height: 12),

            // ── Documento ────────────────────────────────────────────
            if (cliente.tipoDocumento != null || cliente.documento != null) ...[
              _SectionCard(
                titulo: 'Documento',
                icono: Icons.badge_outlined,
                children: [
                  if (cliente.tipoDocumento != null)
                    _InfoRow(label: 'Tipo', valor: cliente.tipoDocumento!),
                  if (cliente.documento != null)
                    _InfoRow(label: 'Número', valor: cliente.documento!),
                ],
              ),
              const SizedBox(height: 12),
            ],

            // ── Citas del cliente ─────────────────────────────────────
            Consumer<CitasProvider>(
              builder: (context, citasProvider, _) {
                final citas = _citasCliente(citasProvider.citas);
                return _ExpandibleSection(
                  titulo: 'Citas',
                  icono: Icons.event_outlined,
                  color: AppColors.secondary,
                  count: citas.length,
                  isLoading: citasProvider.isLoading,
                  emptyText: 'Sin citas registradas',
                  children: citas
                      .map(
                        (c) => _CitaRow(
                          fecha: c.fecha,
                          hora: _formatHora(c.hora),
                          estado: c.estadoCita,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 12),

            // ── Pedidos del cliente ───────────────────────────────────
            Consumer2<VentasProvider, PedidosProvider>(
              builder: (context, ventasProvider, pedidosProvider, _) {
                // Obtener IDs de ventas de este cliente
                final ventaIds = ventasProvider.ventas
                    .where(
                      (v) =>
                          (v.nombreCliente ?? '').toLowerCase() ==
                          cliente.nombre.toLowerCase(),
                    )
                    .map((v) => v.idVenta)
                    .toSet();

                final pedidos =
                    _pedidosCliente(pedidosProvider.pedidos, ventaIds);

                return _ExpandibleSection(
                  titulo: 'Pedidos',
                  icono: Icons.inventory_2_outlined,
                  color: AppColors.warning,
                  count: pedidos.length,
                  isLoading:
                      ventasProvider.isLoading || pedidosProvider.isLoading,
                  emptyText: 'Sin pedidos registrados',
                  children: pedidos
                      .map(
                        (p) => _PedidoRow(
                          servicio:
                              p.nombreServicio ?? 'Servicio #${p.idDetalle}',
                          precio: _formatCOP(p.precio),
                          estado: p.estado,
                          idVenta: p.idVenta,
                        ),
                      )
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sección expandible con contador en el título
// ─────────────────────────────────────────────────────────────────────────────

class _ExpandibleSection extends StatefulWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final int count;
  final bool isLoading;
  final String emptyText;
  final List<Widget> children;

  const _ExpandibleSection({
    required this.titulo,
    required this.icono,
    required this.color,
    required this.count,
    required this.isLoading,
    required this.emptyText,
    required this.children,
  });

  @override
  State<_ExpandibleSection> createState() => _ExpandibleSectionState();
}

class _ExpandibleSectionState extends State<_ExpandibleSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Encabezado clickeable
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(widget.icono, size: 16, color: widget.color),
                  const SizedBox(width: 8),
                  Text(
                    widget.titulo,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.color,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge con contador
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.isLoading ? '…' : '${widget.count}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.muted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // Contenido
          if (_expanded) ...[
            const Divider(height: 1, color: AppColors.border),
            if (widget.isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (widget.children.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.emptyText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.muted,
                  ),
                ),
              )
            else
              ...widget.children,
          ],
        ],
      ),
    );
  }
}

class _CitaRow extends StatelessWidget {
  final String fecha;
  final String hora;
  final String estado;

  const _CitaRow({
    required this.fecha,
    required this.hora,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 16,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$fecha  •  $hora',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          EstadoBadge(texto: estado),
        ],
      ),
    );
  }
}

class _PedidoRow extends StatelessWidget {
  final String servicio;
  final String precio;
  final String estado;
  final int idVenta;

  const _PedidoRow({
    required this.servicio,
    required this.precio,
    required this.estado,
    required this.idVenta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 16,
            color: AppColors.warning,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  servicio,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Venta #$idVenta  •  $precio',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          EstadoBadge(texto: estado),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers reutilizables dentro del archivo
// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final List<Widget> children;

  const _SectionCard({
    required this.titulo,
    required this.icono,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, size: 16, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            ...children,
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
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
