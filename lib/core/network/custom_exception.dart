class CustomException implements Exception {
  String msg;

  CustomException(this.msg);

  @override
  String toString() {
  return msg;
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? msg])
  : super(msg!);
}

class BadRequestException extends CustomException {
  BadRequestException([msg]) : super(msg.toString());
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([msg]) : super(msg.toString());
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? msg]) : super(msg!);
}