import 'dart:io';

class ApiException extends IOException {
  final ApiError error;

  ApiException(this.error,);
}

class ApiError {
  final int statusCode;
  final String message;
  final List<ApiSubError> errors;

  const ApiError({this.statusCode, this.message, this.errors});

  factory ApiError.fromMap(Map<String, dynamic> map) {
    final List<ApiSubError> errors = (map['errors'] as List).map((e) => ApiSubError.fromMap(e)).toList();
    return ApiError(
      statusCode: map['statusCode'] as int,
      message: map['message'] as String,
      errors: errors,
    );
  }
}

class ApiSubError {
  final String domain;
  final String reason;
  final String message;

  const ApiSubError({this.domain, this.reason, this.message,});

  Map<String, dynamic> toMap() {
    return {
      'domain': this.domain,
      'reason': this.reason,
      'message': this.message,
    };
  }

  factory ApiSubError.fromMap(Map<String, dynamic> map) {
    return ApiSubError(
      domain: map['domain'] as String,
      reason: map['reason'] as String,
      message: map['message'] as String,
    );
  }
}
