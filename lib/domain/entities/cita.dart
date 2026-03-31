class Cita {
  final int idCita;
  final String? nombreCliente;
  final String? correoCliente;
  final String fecha;
  final String hora;
  final int idEstadoCita;
  final String estadoCita;
  final String? observaciones;

  const Cita({
    required this.idCita,
    this.nombreCliente,
    this.correoCliente,
    required this.fecha,
    required this.hora,
    required this.idEstadoCita,
    required this.estadoCita,
    this.observaciones,
  });
}
