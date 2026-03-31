// Utilidades de formato — mismo criterio que el frontend
// formatFecha("2025-03-15")  → "15 mar 2025"
// formatHora("14:00:00")     → "2:00 PM"
// formatCOP(150000)          → "$150.000"

const _meses = [
  '', 'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

String formatFecha(String? fecha) {
  if (fecha == null || fecha.isEmpty) return '—';
  try {
    final parts = fecha.split('T')[0].split('-');
    if (parts.length < 3) return fecha;
    final day   = int.parse(parts[2]);
    final month = int.parse(parts[1]);
    final year  = parts[0];
    return '$day ${_meses[month]} $year';
  } catch (_) {
    return fecha;
  }
}

String formatHora(String? hora) {
  if (hora == null || hora.isEmpty) return '—';
  try {
    final parts = hora.split(':');
    var h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    final period = h >= 12 ? 'PM' : 'AM';
    if (h > 12) h -= 12;
    if (h == 0) h = 12;
    final mm = m.toString().padLeft(2, '0');
    return '$h:$mm $period';
  } catch (_) {
    return hora;
  }
}

String formatCOP(num valor) {
  final s = valor.toStringAsFixed(0);
  final buf = StringBuffer('\$');
  final len = s.length;
  for (var i = 0; i < len; i++) {
    if (i > 0 && (len - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}
