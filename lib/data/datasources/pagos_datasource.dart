import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/utils/token_storage.dart';
import '../models/pago_model.dart';

class PagosDatasource {
  Future<List<PagoModel>> getPagos() async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.payments}?limit=500');
    final res = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (res.statusCode != 200) throw Exception('Error al cargar pagos');
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>;
    return data.map((e) => PagoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> cambiarEstadoPago(int idPago, int idEstadoPago) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.payments}/$idPago');
    final res = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id_estado_pago': idEstadoPago}),
    );
    return res.statusCode == 200;
  }
}
