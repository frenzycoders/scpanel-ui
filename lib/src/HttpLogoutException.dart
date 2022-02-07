class HttpLogoutException implements Exception {
  final String message;
  bool loggedOut;
  HttpLogoutException(this.message, this.loggedOut);

  @override
  String toString() {
    return message;
  }
}
