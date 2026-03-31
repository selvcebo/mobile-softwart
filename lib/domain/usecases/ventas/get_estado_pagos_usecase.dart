import '../../repositories/ventas_repository.dart';

class GetEstadoPagosUsecase {
  final VentasRepository _repository;

  GetEstadoPagosUsecase(this._repository);

  Future<Map<String, dynamic>> call(int idVenta) =>
      _repository.getEstadoPagos(idVenta);
}
