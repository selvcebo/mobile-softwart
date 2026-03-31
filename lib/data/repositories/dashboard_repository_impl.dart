import '../../core/errors/exceptions.dart';
import '../../core/utils/token_storage.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDatasource _datasource;

  DashboardRepositoryImpl(this._datasource);

  @override
  Future<DashboardStats> getStats() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw const UnauthorizedException('Sin sesión activa');
    return _datasource.getStats(token);
  }
}
