class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {}
class CouldNotRetrieveNotesException extends CloudStorageException {}
class CouldNotUpdateNoteException extends CloudStorageException {}
class CouldNotDeleteNoteException extends CloudStorageException {}


// Exceptions for user
class CouldNotCreateUserException extends CloudStorageException {}
class CouldNotRetrieveUserException extends CloudStorageException {}
class CouldNotUpdateUserException extends CloudStorageException {}
class CouldNotDeleteUserException extends CloudStorageException {}