import '../../domain/entities/pago.dart';
import '../../domain/repositories/pagos_repository.dart';
import '../datasources/pagos_datasource.dart';

class PagosRepositoryImpl implements PagosRepository {
  final PagosDatasource _datasource;

  PagosRepositoryImpl(this._datasource);

  @override
  Future<List<Pago>> getPagos() => _datasource.getPagos();

  @override
  Future<bool> cambiarEstadoPago(int idPago, int idEstadoPago) =>
      _datasource.cambiarEstadoPago(idPago, idEstadoPago);
}
