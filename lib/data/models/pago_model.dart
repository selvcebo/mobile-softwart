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
    // Backend retorna relaciones en inglés: paymentStatus, paymentMethod, sale
    final ps = json['paymentStatus'] as Map<String, dynamic>?;
    final pm = json['paymentMethod'] as Map<String, dynamic>?;
    final sale = json['sale'] as Map<String, dynamic>?;

    return PagoModel(
      idPago:       json['id_pago']  as int,
      monto:        double.tryParse(json['monto'].toString()) ?? 0,
      fecha:        json['fecha']?.toString() ?? '',
      observacion:  json['observacion'] as String?,
      idVenta:      sale?['id_venta'] as int? ?? 0,
      metodoPago:   pm?['nombre']    as String?,
      idEstadoPago: ps?['id_estado_pago'] as int? ?? 0,
      estadoPago:   ps?['nombre']    as String? ?? '—',
    );
  }
}
