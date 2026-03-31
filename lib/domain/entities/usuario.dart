// Entidad de negocio pura — sin fromJson
class Usuario {
  final int idUsuario;
  final String correo;
  final String rol;
  final int idRol;
  final int? idCliente;
  final String? nombre;

  const Usuario({
    required this.idUsuario,
    required this.correo,
    required this.rol,
    required this.idRol,
    this.idCliente,
    this.nombre,
  });

  bool get isAdmin => idRol == 1;
  bool get isEmpleado => idRol == 2;
}
