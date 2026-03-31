import 'package:flutter/material.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/venta.dart';
import '../../domain/usecases/ventas/get_ventas_usecase.dart';
import '../../domain/usecases/ventas/get_estado_pagos_usecase.dart';

class VentasProvider extends ChangeNotifier {
  final GetVentasUsecase _getVentasUsecase;
  final GetEstadoPagosUsecase _getEstadoPagosUsecase;

  VentasProvider({
    required GetVentasUsecase getVentasUsecase,
    required GetEstadoPagosUsecase getEstadoPagosUsecase,
  })  : _getVentasUsecase = getVentasUsecase,
        _getEstadoPagosUsecase = getEstadoPagosUsecase;

  bool _isLoading = false;
  String? _error;
  List<Venta> _ventas = [];
  Map<String, dynamic>? _estadoPagos;
  bool _isLoadingPagos = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Venta> get ventas => _ventas;
  Map<String, dynamic>? get estadoPagos => _estadoPagos;
  bool get isLoadingPagos => _isLoadingPagos;

  Future<void> cargar() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _ventas = await _getVentasUsecase();
    } catch (e) {
      _error = e is AppException ? e.message : 'Error al cargar ventas';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarEstadoPagos(int idVenta) async {
    _isLoadingPagos = true;
    _estadoPagos = null;
    notifyListeners();

    try {
      _estadoPagos = await _getEstadoPagosUsecase(idVenta);
    } catch (e) {
      _error = e is AppException ? e.message : 'Error al cargar pagos';
    } finally {
      _isLoadingPagos = false;
      notifyListeners();
    }
  }
}
