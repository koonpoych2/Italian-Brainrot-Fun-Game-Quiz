/// Base exception class for application-specific errors
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noConnection() => const NetworkException(
    message: 'No internet connection. Please check your network settings.',
    code: 'NO_CONNECTION',
  );

  factory NetworkException.timeout() => const NetworkException(
    message: 'Connection timed out. Please try again.',
    code: 'TIMEOUT',
  );

  factory NetworkException.serverError([String? details]) => NetworkException(
    message: details ?? 'Server error occurred. Please try again later.',
    code: 'SERVER_ERROR',
  );

  factory NetworkException.unknown([dynamic error, StackTrace? stackTrace]) =>
      NetworkException(
        message: 'An unexpected network error occurred.',
        code: 'UNKNOWN',
        originalError: error,
        stackTrace: stackTrace,
      );
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory StorageException.readError([String? key]) => StorageException(
    message: key != null
        ? 'Failed to read data for key: $key'
        : 'Failed to read data from storage.',
    code: 'READ_ERROR',
  );

  factory StorageException.writeError([String? key]) => StorageException(
    message: key != null
        ? 'Failed to write data for key: $key'
        : 'Failed to write data to storage.',
    code: 'WRITE_ERROR',
  );

  factory StorageException.deleteError([String? key]) => StorageException(
    message: key != null
        ? 'Failed to delete data for key: $key'
        : 'Failed to delete data from storage.',
    code: 'DELETE_ERROR',
  );

  factory StorageException.notFound(String key) => StorageException(
    message: 'Data not found for key: $key',
    code: 'NOT_FOUND',
  );
}

/// Quiz-related exceptions
class QuizException extends AppException {
  const QuizException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory QuizException.noQuestionsAvailable() => const QuizException(
    message: 'No questions available for this quiz.',
    code: 'NO_QUESTIONS',
  );

  factory QuizException.invalidAnswer() => const QuizException(
    message: 'Invalid answer submitted.',
    code: 'INVALID_ANSWER',
  );

  factory QuizException.quizNotFound(String quizId) =>
      QuizException(message: 'Quiz not found: $quizId', code: 'QUIZ_NOT_FOUND');

  factory QuizException.alreadyCompleted() => const QuizException(
    message: 'This quiz has already been completed.',
    code: 'ALREADY_COMPLETED',
  );

  factory QuizException.timeExpired() => const QuizException(
    message: 'Time has expired for this quiz.',
    code: 'TIME_EXPIRED',
  );
}

/// Ad-related exceptions
class AdException extends AppException {
  const AdException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AdException.failedToLoad([String? adType]) => AdException(
    message: adType != null
        ? 'Failed to load $adType ad.'
        : 'Failed to load advertisement.',
    code: 'LOAD_FAILED',
  );

  factory AdException.notReady([String? adType]) => AdException(
    message: adType != null
        ? '$adType ad is not ready to show.'
        : 'Advertisement is not ready to show.',
    code: 'NOT_READY',
  );

  factory AdException.showFailed([String? adType]) => AdException(
    message: adType != null
        ? 'Failed to show $adType ad.'
        : 'Failed to show advertisement.',
    code: 'SHOW_FAILED',
  );

  factory AdException.rewardNotEarned() => const AdException(
    message: 'Reward was not earned. Please watch the full ad.',
    code: 'REWARD_NOT_EARNED',
  );
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.unauthorized() => const AuthException(
    message: 'You are not authorized to perform this action.',
    code: 'UNAUTHORIZED',
  );

  factory AuthException.sessionExpired() => const AuthException(
    message: 'Your session has expired. Please log in again.',
    code: 'SESSION_EXPIRED',
  );

  factory AuthException.invalidCredentials() => const AuthException(
    message: 'Invalid credentials provided.',
    code: 'INVALID_CREDENTIALS',
  );
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.invalidInput(String field, String reason) =>
      ValidationException(
        message: 'Invalid input for $field: $reason',
        code: 'INVALID_INPUT',
        fieldErrors: {
          field: [reason],
        },
      );

  factory ValidationException.requiredField(String field) =>
      ValidationException(
        message: '$field is required.',
        code: 'REQUIRED_FIELD',
        fieldErrors: {
          field: ['This field is required'],
        },
      );

  factory ValidationException.multipleErrors(
    Map<String, List<String>> errors,
  ) => ValidationException(
    message: 'Multiple validation errors occurred.',
    code: 'MULTIPLE_ERRORS',
    fieldErrors: errors,
  );
}

/// Generic/Unknown exceptions
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred.',
    super.code = 'UNKNOWN',
    super.originalError,
    super.stackTrace,
  });

  factory UnknownException.fromError(dynamic error, [StackTrace? stackTrace]) =>
      UnknownException(
        message: error?.toString() ?? 'An unexpected error occurred.',
        originalError: error,
        stackTrace: stackTrace,
      );
}

/// Result wrapper for handling success and failure states
sealed class Result<T> {
  const Result();

  /// Creates a success result with data
  factory Result.success(T data) = Success<T>;

  /// Creates a failure result with an exception
  factory Result.failure(AppException exception) = Failure<T>;

  /// Whether this result is a success
  bool get isSuccess => this is Success<T>;

  /// Whether this result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the data if success, otherwise null
  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    Failure<T>() => null,
  };

  /// Get the exception if failure, otherwise null
  AppException? get exceptionOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(:final exception) => exception,
  };

  /// Map success value to another type
  Result<R> map<R>(R Function(T data) mapper) => switch (this) {
    Success<T>(:final data) => Result.success(mapper(data)),
    Failure<T>(:final exception) => Result.failure(exception),
  };

  /// Handle both success and failure cases
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) => switch (this) {
    Success<T>(:final data) => success(data),
    Failure<T>(:final exception) => failure(exception),
  };

  /// Handle both cases with optional handlers
  R? maybeWhen<R>({
    R Function(T data)? success,
    R Function(AppException exception)? failure,
    R Function()? orElse,
  }) => switch (this) {
    Success<T>(:final data) => success?.call(data) ?? orElse?.call(),
    Failure<T>(:final exception) => failure?.call(exception) ?? orElse?.call(),
  };
}

/// Success result containing data
final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Failure result containing an exception
final class Failure<T> extends Result<T> {
  final AppException exception;
  const Failure(this.exception);
}
