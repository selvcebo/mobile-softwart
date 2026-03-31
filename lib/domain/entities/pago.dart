class Pago {
  final int idPago;
  final double monto;
  final String fecha;
  final String? observacion;
  final int idVenta;
  final String? metodoPago;
  final int idEstadoPago;
  final String estadoPago;

  const Pago({
    required this.idPago,
    required this.monto,
    required this.fecha,
    this.observacion,
    required this.idVenta,
    this.metodoPago,
    required this.idEstadoPago,
    required this.estadoPago,
  });
}
