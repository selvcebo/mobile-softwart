import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/venta_model.dart';

class VentasDatasource {
  Future<List<VentaModel>> getVentas(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sales}?limit=500'),
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
          'Error al cargar ventas (${response.statusCode})',
        );
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>;
      return data
          .map((e) => VentaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException('Error de conexión: $e');
    }
  }

  Future<Map<String, dynamic>> getEstadoPagos({
    required String token,
    required int idVenta,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.paymentPlan(idVenta)}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 401) {
        throw const UnauthorizedException('Sesión expirada');
      }
      if (response.statusCode != 200) {
        throw ServerException('Error al cargar estado de pagos');
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['data'] as Map<String, dynamic>? ?? body;
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException('Error de conexión: $e');
    }
  }
}
