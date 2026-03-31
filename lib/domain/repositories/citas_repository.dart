import '../entities/cita.dart';

abstract class CitasRepository {
  Future<List<Cita>> getCitas();
  Future<void> cambiarEstado({required int idCita, required int idEstado});
}
