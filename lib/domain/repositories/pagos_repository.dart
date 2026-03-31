import '../entities/pago.dart';

abstract class PagosRepository {
  Future<List<Pago>> getPagos();
  Future<bool> cambiarEstadoPago(int idPago, int idEstadoPago);
}
