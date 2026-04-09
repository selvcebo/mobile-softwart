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

  // Appointments
  static const String appointments = '/appointments';
  static String changeAppointmentStatus(int id) =>
      '/appointment-status/cita/$id/estado';

  // Sale Details (services/orders)
  static const String saleDetails = '/sale-details';
  static String changeSaleDetailStatus(int id) =>
      '/service-status/detalle/$id/estado';

  // Sales
  static const String sales = '/sales';
  static String paymentPlan(int id) => '/sales/$id/payment-plan';

  // Clients
  static const String clients = '/clients';

  // Payments
  static const String payments = '/payments';
}
