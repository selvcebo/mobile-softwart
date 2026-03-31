import '../../domain/entities/pedido.dart';

class PedidoModel extends Pedido {
  const PedidoModel({
    required super.idDetalle,
    required super.idVenta,
    super.nombreServicio,
    super.descripcion,
    required super.idEstado,
    required super.estado,
    required super.precio,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    // El backend retorna relaciones anidadas:
    // venta{id_venta,...}, servicio{nombre,descripcion}, estadoServicio{id_estado,nombre}
    final venta = json['venta'] as Map<String, dynamic>?;
    final servicio = json['servicio'] as Map<String, dynamic>?;
    final estadoServicio = json['estadoServicio'] as Map<String, dynamic>?;

    return PedidoModel(
      idDetalle: json['id_detalle'] as int,
      idVenta: venta?['id_venta'] as int? ?? json['id_venta'] as int? ?? 0,
      nombreServicio: servicio?['nombre'] as String? ??
          json['nombre_servicio'] as String?,
      descripcion: servicio?['descripcion'] as String? ??
          json['descripcion'] as String?,
      idEstado: estadoServicio?['id_estado'] as int? ??
          json['id_estado'] as int? ??
          1,
      estado: estadoServicio?['nombre'] as String? ??
          json['estado'] as String? ??
          json['nombre_estado'] as String? ??
          '',
      // precio viene como string decimal desde PostgreSQL
      precio: double.tryParse(json['precio']?.toString() ?? '0') ?? 0.0,
    );
  }
}
