import '../../entities/cliente.dart';
import '../../repositories/clientes_repository.dart';

class GetClientesUsecase {
  final ClientesRepository _repository;

  GetClientesUsecase(this._repository);

  Future<List<Cliente>> call() => _repository.getClientes();
}
