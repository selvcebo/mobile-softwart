import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/cliente_model.dart';

class ClientesDatasource {
  Future<List<ClienteModel>> getClientes(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.clientes}?limit=500'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 401) {
        throw const UnauthorizedException('Sesión expirada');
      }
      if (response.statusCode != 200) {
        throw ServerException(
          'Error al cargar clientes (${response.statusCode})',
        );
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>;
      return data
          .map((e) => ClienteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException('Error de conexión: $e');
    }
  }
}
