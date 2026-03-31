// Constantes de API — SoftwArt Mobile
class ApiConstants {
  // Producción (Render)
  static const String baseUrl = 'https://softwart-backend.onrender.com/api';
  // Desarrollo local:
  // static const String baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:3001/api'; // iOS simulator

  // Auth
  static const String login = '/auth/login';

  // Dashboard
  static const String dashboard = '/dashboard';

  // Citas
  static const String citas = '/citas';
  static String cambiarEstadoCita(int id) => '/estado-cita/cita/$id/estado';

  // Pedidos (detalle-venta)
  static const String pedidos = '/detalle-venta';
  static String cambiarEstadoPedido(int id) =>
      '/estado-servicio/detalle/$id/estado';

  // Ventas
  static const String ventas = '/ventas';
  static String estadoPagosVenta(int id) => '/ventas/$id/estado-pagos';

  // Clientes
  static const String clientes = '/clientes';

  // Pagos
  static const String pagos = '/pagos';
}
