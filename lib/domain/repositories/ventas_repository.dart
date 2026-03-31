import '../entities/venta.dart';

abstract class VentasRepository {
  Future<List<Venta>> getVentas();
  Future<Map<String, dynamic>> getEstadoPagos(int idVenta);
}
