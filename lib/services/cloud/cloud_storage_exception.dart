class CloudStorageException implements Exception {
  const CloudStorageException();
}

// Exceptions for user
class CouldNotCreateUserException extends CloudStorageException {}
class CouldNotRetrieveUserException extends CloudStorageException {}
class CouldNotUpdateUserException extends CloudStorageException {}
class CouldNotDeleteUserException extends CloudStorageException {}

// Excpetions for Tasks
class CouldNotCreateTaskException extends CloudStorageException {}
class CouldNotDeleteTaskException extends CloudStorageException {}
class CouldNotUpdateTaskException extends CloudStorageException {}