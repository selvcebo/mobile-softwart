import 'package:flutter/material.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/usecases/dashboard/get_dashboard_usecase.dart';

class DashboardProvider extends ChangeNotifier {
  final GetDashboardUsecase _getStatsUsecase;

  DashboardProvider({required GetDashboardUsecase getStatsUsecase})
      : _getStatsUsecase = getStatsUsecase;

  bool _isLoading = false;
  String? _error;
  DashboardStats? _stats;

  bool get isLoading => _isLoading;
  String? get error => _error;
  DashboardStats? get stats => _stats;

  Future<void> cargar() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await _getStatsUsecase();
    } catch (e) {
      _error = e is AppException ? e.message : 'Error al cargar dashboard';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
