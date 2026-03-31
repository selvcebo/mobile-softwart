import '../../repositories/pedidos_repository.dart';

class CambiarEstadoPedidoUsecase {
  final PedidosRepository _repository;

  CambiarEstadoPedidoUsecase(this._repository);

  Future<void> call({required int idDetalle, required int idEstado}) =>
      _repository.cambiarEstado(idDetalle: idDetalle, idEstado: idEstado);
}
