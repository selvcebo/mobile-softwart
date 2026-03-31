import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'estado_badge.dart';

/// Selector de estado con chips visuales coloreados por tipo de estado.
class EstadoChipSelector extends StatelessWidget {
  final List<({int id, String nombre})> opciones;
  final int? valorActual;
  final ValueChanged<int> onChanged;

  const EstadoChipSelector({
    super.key,
    required this.opciones,
    required this.valorActual,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: opciones.map((e) {
        final seleccionado = valorActual == e.id;
        final color = EstadoBadge.colorForEstado(e.nombre);
        return GestureDetector(
          onTap: () => onChanged(e.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: seleccionado
                  ? color.withValues(alpha: 0.14)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: seleccionado ? color : AppColors.border,
                width: seleccionado ? 1.5 : 1,
              ),
            ),
            child: Text(
              e.nombre,
              style: TextStyle(
                fontSize: 13,
                fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
                color: seleccionado ? color : AppColors.muted,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
