import '../../entities/pedido.dart';
import '../../repositories/pedidos_repository.dart';

class GetPedidosUsecase {
  final PedidosRepository _repository;

  GetPedidosUsecase(this._repository);

  Future<List<Pedido>> call() => _repository.getPedidos();
}
