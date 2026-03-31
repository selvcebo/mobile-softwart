import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Persistencia del token JWT usando shared_preferences
class TokenStorage {
  static const _keyToken = 'token';

  // Guardar token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Leer token (null si no existe)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Borrar token (logout)
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  // Verificar si el token existe y no está expirado
  static Future<bool> hasValidToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      // Agregar padding base64 si es necesario
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> jsonPayload = jsonDecode(decoded);
      final exp = jsonPayload['exp'] as int?;
      if (exp == null) return false;
      final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isBefore(expDate);
    } catch (_) {
      return false;
    }
  }
}
