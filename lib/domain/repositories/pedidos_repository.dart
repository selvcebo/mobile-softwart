import '../entities/pedido.dart';

abstract class PedidosRepository {
  Future<List<Pedido>> getPedidos();
  Future<void> cambiarEstado({required int idDetalle, required int idEstado});
}
