import '../entities/cliente.dart';

abstract class ClientesRepository {
  Future<List<Cliente>> getClientes();
}
