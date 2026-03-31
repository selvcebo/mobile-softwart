import 'package:flutter/material.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/cita.dart';
import '../../domain/usecases/citas/get_citas_usecase.dart';
import '../../domain/usecases/citas/cambiar_estado_cita_usecase.dart';

class CitasProvider extends ChangeNotifier {
  final GetCitasUsecase _getCitasUsecase;
  final CambiarEstadoCitaUsecase _cambiarEstadoUsecase;

  CitasProvider({
    required GetCitasUsecase getCitasUsecase,
    required CambiarEstadoCitaUsecase cambiarEstadoUsecase,
  })  : _getCitasUsecase = getCitasUsecase,
        _cambiarEstadoUsecase = cambiarEstadoUsecase;

  bool _isLoading = false;
  String? _error;
  List<Cita> _citas = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Cita> get citas => _citas;

  Future<void> cargar() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _citas = await _getCitasUsecase();
    } catch (e) {
      _error = e is AppException ? e.message : 'Error al cargar citas';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cambiarEstado(int idCita, int idEstado) async {
    try {
      await _cambiarEstadoUsecase(idCita: idCita, idEstado: idEstado);
      await cargar();
      return true;
    } catch (e) {
      _error = e is AppException ? e.message : 'Error al cambiar estado';
      notifyListeners();
      return false;
    }
  }
}
