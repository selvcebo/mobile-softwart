import '../../entities/pago.dart';
import '../../repositories/pagos_repository.dart';

class GetPagosUsecase {
  final PagosRepository _repo;
  GetPagosUsecase(this._repo);
  Future<List<Pago>> call() => _repo.getPagos();
}
