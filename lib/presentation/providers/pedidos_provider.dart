import 'package:flutter/material.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/pedido.dart';
import '../../domain/usecases/pedidos/get_pedidos_usecase.dart';
import '../../domain/usecases/pedidos/cambiar_estado_pedido_usecase.dart';

class PedidosProvider extends ChangeNotifier {
  final GetPedidosUsecase _getPedidosUsecase;
  final CambiarEstadoPedidoUsecase _cambiarEstadoUsecase;

  PedidosProvider({
    required GetPedidosUsecase getPedidosUsecase,
    required CambiarEstadoPedidoUsecase cambiarEstadoUsecase,
  })  : _getPedidosUsecase = getPedidosUsecase,
        _cambiarEstadoUsecase = cambiarEstadoUsecase;

  bool _isLoading = false;
  String? _error;
  List<Pedido> _pedidos = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Pedido> get pedidos => _pedidos;

  Future<void> cargar() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pedidos = await _getPedidosUsecase();
    } catch (e) {
      _error = e is AppException ? e.message : 'Error al cargar pedidos';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cambiarEstado(int idDetalle, int idEstado) async {
    try {
      await _cambiarEstadoUsecase(idDetalle: idDetalle, idEstado: idEstado);
      await cargar();
      return true;
    } catch (e) {
      _error = e is AppException ? e.message : 'Error al cambiar estado';
      notifyListeners();
      return false;
    }
  }
}
