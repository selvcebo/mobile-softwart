import '../../repositories/pagos_repository.dart';

class CambiarEstadoPagoUsecase {
  final PagosRepository _repo;
  CambiarEstadoPagoUsecase(this._repo);
  Future<bool> call(int idPago, int idEstadoPago) =>
      _repo.cambiarEstadoPago(idPago, idEstadoPago);
}
