import '../../entities/venta.dart';
import '../../repositories/ventas_repository.dart';

class GetVentasUsecase {
  final VentasRepository _repository;

  GetVentasUsecase(this._repository);

  Future<List<Venta>> call() => _repository.getVentas();
}
