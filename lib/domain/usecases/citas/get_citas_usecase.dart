import '../../entities/cita.dart';
import '../../repositories/citas_repository.dart';

class GetCitasUsecase {
  final CitasRepository _repository;

  GetCitasUsecase(this._repository);

  Future<List<Cita>> call() => _repository.getCitas();
}
