import '../../repositories/citas_repository.dart';

class CambiarEstadoCitaUsecase {
  final CitasRepository _repository;

  CambiarEstadoCitaUsecase(this._repository);

  Future<void> call({required int idCita, required int idEstado}) =>
      _repository.cambiarEstado(idCita: idCita, idEstado: idEstado);
}
