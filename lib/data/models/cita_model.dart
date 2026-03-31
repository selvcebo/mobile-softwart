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
    // El backend retorna relaciones anidadas: cliente{nombre,correo}, estadoCita{nombre}
    final cliente = json['cliente'] as Map<String, dynamic>?;
    final estadoCita = json['estadoCita'] as Map<String, dynamic>?;

    return CitaModel(
      idCita: json['id_cita'] as int,
      // nombre_cliente puede venir plano (en algunos queries) o anidado
      nombreCliente: json['nombre_cliente'] as String? ??
          cliente?['nombre'] as String?,
      correoCliente: json['correo_cliente'] as String? ??
          cliente?['correo'] as String?,
      fecha: json['fecha'] as String? ?? '',
      hora: json['hora'] as String? ?? '',
      idEstadoCita: json['id_estado_cita'] as int? ?? 1,
      estadoCita: json['estado_cita'] as String? ??
          estadoCita?['nombre'] as String? ??
          json['nombre_estado'] as String? ??
          '',
      observaciones: json['observaciones'] as String? ??
          json['observacion'] as String?,
    );
  }
}
