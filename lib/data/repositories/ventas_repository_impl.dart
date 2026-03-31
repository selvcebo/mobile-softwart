import '../../core/errors/exceptions.dart';
import '../../core/utils/token_storage.dart';
import '../../domain/entities/venta.dart';
import '../../domain/repositories/ventas_repository.dart';
import '../datasources/ventas_datasource.dart';

class VentasRepositoryImpl implements VentasRepository {
  final VentasDatasource _datasource;

  VentasRepositoryImpl(this._datasource);

  Future<String> _getToken() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw const UnauthorizedException('Sin sesión activa');
    return token;
  }

  @override
  Future<List<Venta>> getVentas() async {
    return _datasource.getVentas(await _getToken());
  }

  @override
  Future<Map<String, dynamic>> getEstadoPagos(int idVenta) async {
    return _datasource.getEstadoPagos(
      token: await _getToken(),
      idVenta: idVenta,
    );
  }
}
