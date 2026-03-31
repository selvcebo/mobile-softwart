import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Botón de filtro que abre un popover vertical posicionado debajo del botón.
/// Úsalo así:
///   FiltroMenuButton(
///     opciones: const ['Pendiente', 'Completada', ...],
///     filtroActual: _filtroEstado,
///     onSelect: (v) => setState(() => _filtroEstado = v),
///   )
class FiltroMenuButton extends StatefulWidget {
  final List<String> opciones;
  final String? filtroActual;
  final void Function(String?) onSelect;
  /// Ancho del popover (default: 210)
  final double anchoPopover;

  const FiltroMenuButton({
    super.key,
    required this.opciones,
    required this.filtroActual,
    required this.onSelect,
    this.anchoPopover = 210,
  });

  @override
  State<FiltroMenuButton> createState() => _FiltroMenuButtonState();
}

class _FiltroMenuButtonState extends State<FiltroMenuButton> {
  final _buttonKey = GlobalKey();

  void _abrirPopover() {
    final ctx = _buttonKey.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final btnPos = box.localToGlobal(Offset.zero, ancestor: overlay);
    final double top = btnPos.dy + box.size.height + 6;
    // Alinear el borde derecho del popover con el borde derecho del botón
    final double right =
        overlay.size.width - btnPos.dx - box.size.width;

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) => _FiltroPopoverDialog(
        top: top,
        right: right,
        ancho: widget.anchoPopover,
        opciones: widget.opciones,
        filtroActual: widget.filtroActual,
        onSelect: (val) {
          Navigator.pop(ctx);
          widget.onSelect(val);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activo = widget.filtroActual != null;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          key: _buttonKey,
          icon: Icon(
            Icons.filter_list_rounded,
            color: activo ? AppColors.primary : AppColors.muted,
          ),
          tooltip: 'Filtros',
          onPressed: _abrirPopover,
        ),
        if (activo)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _FiltroPopoverDialog extends StatelessWidget {
  final double top;
  final double right;
  final double ancho;
  final List<String> opciones;
  final String? filtroActual;
  final void Function(String?) onSelect;

  const _FiltroPopoverDialog({
    required this.top,
    required this.right,
    required this.ancho,
    required this.opciones,
    required this.filtroActual,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Capa transparente para cerrar al tocar fuera
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: const SizedBox.expand(),
        ),
        // Popover posicionado
        Positioned(
          top: top,
          right: right,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            shadowColor: Colors.black26,
            child: SizedBox(
              width: ancho,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Encabezado
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.filter_list_rounded,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Filtrar por estado',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                        const Spacer(),
                        if (filtroActual != null)
                          GestureDetector(
                            onTap: () => onSelect(null),
                            child: const Text(
                              'Limpiar',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  // Opción "Todos"
                  _OpcionItem(
                    label: 'Todos',
                    selected: filtroActual == null,
                    onTap: () => onSelect(null),
                  ),
                  // Opciones individuales
                  ...opciones.map(
                    (op) => _OpcionItem(
                      label: op,
                      selected: filtroActual == op,
                      onTap: () =>
                          onSelect(filtroActual == op ? null : op),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OpcionItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OpcionItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected
                      ? AppColors.secondary
                      : AppColors.foreground,
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: AppColors.secondary,
              ),
          ],
        ),
      ),
    );
  }
}
