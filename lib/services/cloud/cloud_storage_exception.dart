class CloudStorageException implements Exception {
  const CloudStorageException();
}

// Exceptions for user
class CouldNotCreateUserException extends CloudStorageException {}

class CouldNotRetrieveUserException extends CloudStorageException {}

class CouldNotUpdateUserException extends CloudStorageException {}

class CouldNotDeleteUserException extends CloudStorageException {}

class ErrorGettingUserFromTheDatabase extends CloudStorageException {}

// Excpetions for Tasks
class CouldNotCreateTaskException extends CloudStorageException {}

class CouldNotDeleteTaskException extends CloudStorageException {}

class CouldNotUpdateTaskException extends CloudStorageException {}

class CouldNotCreateOfferException extends CloudStorageException {}

// Exception for Taskers
class CouldNotCreateTaskerException implements Exception {
  final String message;
  CouldNotCreateTaskerException([this.message = '']);

  @override
  String toString() => message.isEmpty ? 'Could not create tasker' : message;
}

class CouldNotUpdateRatingException implements Exception {
  final String message;
  CouldNotUpdateRatingException([this.message = '']);

  @override
  String toString() => message.isEmpty ? 'Could not update rating' : message;
}

// Exception for Offers
class EmptyOffersSnapshotException extends CloudStorageException {}

// Exception for Comments
class EmptyCommentsSnapshotException extends CloudStorageException {}
