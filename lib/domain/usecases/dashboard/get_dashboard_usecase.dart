import '../../entities/dashboard_stats.dart';
import '../../repositories/dashboard_repository.dart';

class GetDashboardUsecase {
  final DashboardRepository _repository;

  GetDashboardUsecase(this._repository);

  Future<DashboardStats> call() => _repository.getStats();
}
