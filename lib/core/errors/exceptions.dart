// Excepciones de la app — SoftwArt Mobile

class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'No autorizado'])
      : super(message);
}

class ForbiddenException extends AppException {
  const ForbiddenException([String message = 'Acceso denegado'])
      : super(message);
}

class NotFoundException extends AppException {
  const NotFoundException([String message = 'Recurso no encontrado'])
      : super(message);
}

class ServerException extends AppException {
  const ServerException([String message = 'Error del servidor'])
      : super(message);
}

class NetworkException extends AppException {
  const NetworkException([String message = 'Error de conexión'])
      : super(message);
}
