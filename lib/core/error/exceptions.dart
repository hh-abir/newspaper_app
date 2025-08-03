abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({required this.message, this.statusCode});

  @override
  String toString() {
    return 'AppException: $message${statusCode != null ? ' (Status code: $statusCode)' : ''}';
  }
}

class ServerException extends AppException {
  ServerException({required super.message, super.statusCode});
}

class CacheException extends AppException {
  CacheException({required super.message, super.statusCode});
}

class NetworkException extends AppException {
  NetworkException({required super.message, super.statusCode});
}
