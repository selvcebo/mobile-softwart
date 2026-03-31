import '../../domain/entities/pago.dart';

class PagoModel extends Pago {
  const PagoModel({
    required super.idPago,
    required super.monto,
    required super.fecha,
    super.observacion,
    required super.idVenta,
    super.metodoPago,
    required super.idEstadoPago,
    required super.estadoPago,
  });

  factory PagoModel.fromJson(Map<String, dynamic> json) {
    final ep = json['estadoPago'] as Map<String, dynamic>?;
    final mp = json['metodoPago'] as Map<String, dynamic>?;
    final venta = json['venta'] as Map<String, dynamic>?;

    return PagoModel(
      idPago:       json['id_pago']  as int,
      monto:        double.tryParse(json['monto'].toString()) ?? 0,
      fecha:        json['fecha']?.toString() ?? '',
      observacion:  json['observacion'] as String?,
      idVenta:      venta?['id_venta'] as int? ?? 0,
      metodoPago:   mp?['nombre']    as String?,
      idEstadoPago: ep?['id_estado_pago'] as int? ?? 0,
      estadoPago:   ep?['nombre']    as String? ?? '—',
    );
  }
}
