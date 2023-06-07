class FetchDataException implements Exception {
  final String _message;
  final _prefix = 'Error during HTTP call: ';

  FetchDataException(this._message);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}
