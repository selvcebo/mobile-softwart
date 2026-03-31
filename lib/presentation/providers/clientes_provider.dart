import 'package:flutter/material.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/usecases/clientes/get_clientes_usecase.dart';

class ClientesProvider extends ChangeNotifier {
  final GetClientesUsecase _getClientesUsecase;

  ClientesProvider({required GetClientesUsecase getClientesUsecase})
      : _getClientesUsecase = getClientesUsecase;

  bool _isLoading = false;
  String? _error;
  List<Cliente> _clientes = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Cliente> get clientes => _clientes;

  Future<void> cargar() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _clientes = await _getClientesUsecase();
    } catch (e) {
      _error = e is AppException ? e.message : 'Error al cargar clientes';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
