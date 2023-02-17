class Error {
  final String code;
  final String message;

  Error({required this.code, required this.message});
}

extension ErrorExtension on List<Error> {
  List<Error> errorsByCode(String code) =>
      where((element) => element.code.contains(code)).toList();
}
