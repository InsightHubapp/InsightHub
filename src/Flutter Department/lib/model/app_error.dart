class AppError {
  final String? message;
  final String? error;
  final String? msg;
  final List<String>? errors;

  AppError({
    this.message,
    this.error,
    this.msg,
    this.errors,
  });

  factory AppError.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'];
    return AppError(
      message: json['message'] as String?,
      error: json['error'] as String?,
      msg: json['msg'] as String?,
      errors: rawErrors is List
          ? rawErrors.map((error) => error.toString()).toList()
          : rawErrors != null
              ? [rawErrors.toString()]
              : null,
    );
  }
  String getErrorMessage() {
    if (message != null) return message!;
    if (error != null) return error!;
    if (msg != null) return msg!;
    if (errors != null && errors!.isNotEmpty) return errors!.join(', ');
    return 'Unknown error';
  }
}
