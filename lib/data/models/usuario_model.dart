import '../../domain/entities/usuario.dart';

// Modelo de datos con fromJson — mapea la respuesta del backend
class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.idUsuario,
    required super.correo,
    required super.rol,
    required super.idRol,
    super.idCliente,
    super.nombre,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      idUsuario: json['id_usuario'] as int,
      correo: json['correo'] as String,
      rol: json['rol'] as String,
      idRol: json['id_rol'] as int? ?? _parseRol(json['rol'] as String),
      idCliente: json['id_cliente'] as int?,
      nombre: json['nombre'] as String?,
    );
  }

  // Fallback si el backend no devuelve id_rol directamente
  static int _parseRol(String rol) {
    switch (rol.toLowerCase()) {
      case 'admin':
        return 1;
      case 'empleado':
        return 2;
      case 'cliente':
        return 3;
      default:
        return 0;
    }
  }

  Map<String, dynamic> toJson() => {
    'id_usuario': idUsuario,
    'correo': correo,
    'rol': rol,
    'id_rol': idRol,
    'id_cliente': idCliente,
    'nombre': nombre,
  };
}
