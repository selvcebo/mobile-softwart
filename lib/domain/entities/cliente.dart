class Cliente {
  final int idCliente;
  final String nombre;
  final String correo;
  final String? telefono;
  final String? direccion;
  final String? tipoDocumento;
  final String? documento;
  final bool activo;

  const Cliente({
    required this.idCliente,
    required this.nombre,
    required this.correo,
    this.telefono,
    this.direccion,
    this.tipoDocumento,
    this.documento,
    this.activo = true,
  });
}
