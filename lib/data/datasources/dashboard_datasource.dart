import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/dashboard_model.dart';

class DashboardDatasource {
  Future<DashboardModel> getStats(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dashboard}'),
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
          'Error al cargar dashboard (${response.statusCode})',
        );
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? body;
      return DashboardModel.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException('Error de conexión: $e');
    }
  }
}
