import '../../domain/entities/cita.dart';

class CitaModel extends Cita {
  const CitaModel({
    required super.idCita,
    super.nombreCliente,
    super.correoCliente,
    required super.fecha,
    required super.hora,
    required super.idEstadoCita,
    required super.estadoCita,
    super.observaciones,
  });

  factory CitaModel.fromJson(Map<String, dynamic> json) {
    // Backend retorna relaciones en inglés: client{nombre,correo}, appointmentStatus{nombre}
    final client = json['client'] as Map<String, dynamic>?;
    final status = json['appointmentStatus'] as Map<String, dynamic>?;

    return CitaModel(
      idCita: json['id_cita'] as int,
      nombreCliente: client?['nombre'] as String?,
      correoCliente: client?['correo'] as String?,
      fecha: json['fecha'] as String? ?? '',
      hora: json['hora'] as String? ?? '',
      idEstadoCita: status?['id_estado_cita'] as int? ?? 1,
      estadoCita: status?['nombre'] as String? ?? '',
      observaciones: json['observacion'] as String?,
    );
  }
}
