import '../../domain/entities/cliente.dart';

class ClienteModel extends Cliente {
  const ClienteModel({
    required super.idCliente,
    required super.nombre,
    required super.correo,
    super.telefono,
    super.direccion,
    super.tipoDocumento,
    super.documento,
    super.activo,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      idCliente: json['id_cliente'] as int,
      nombre: json['nombre'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      tipoDocumento: json['tipoDocumento'] as String?,
      documento: json['documento'] as String?,
      activo: json['estado'] as bool? ?? true,
    );
  }
}
