import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/usuario_model.dart';

// Fuente de datos remota para autenticación
class AuthDatasource {
  // POST /api/auth/login
  Future<({UsuarioModel usuario, String token})> login({
    required String correo,
    required String clave,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'correo': correo, 'clave': clave}),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () => throw const NetworkException(
              'El servidor tardó demasiado en responder. Puede estar iniciando, intenta de nuevo en un momento.',
            ),
          );

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 401) {
        throw const UnauthorizedException('Correo o clave incorrectos');
      }
      if (response.statusCode == 403) {
        throw const ForbiddenException('Solo Admin y Empleado pueden acceder');
      }
      if (response.statusCode != 200) {
        final message = body['message'] as String? ?? 'Error del servidor';
        throw ServerException(message);
      }

      if (body['success'] != true) {
        final message = body['message'] as String? ?? 'Login fallido';
        throw AppException(message);
      }

      final token = body['token'] as String;
      final data = body['data'] as Map<String, dynamic>;
      final usuario = UsuarioModel.fromJson(data);

      // Verificar que no sea cliente
      if (usuario.idRol == 3) {
        throw const ForbiddenException(
          'Esta app es solo para Admin y Empleado',
        );
      }

      return (usuario: usuario, token: token);
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException('Error de conexión: $e');
    }
  }
}
