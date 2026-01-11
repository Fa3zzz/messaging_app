//login exceptions

class InvalidCredentialsAuthException implements Exception{}

class InvalidEmailAuthException implements Exception {}

//register exceptions

class WeakPasswordAuthExceptions implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

//generic. exceptions

class GenericAuthExceptions implements Exception {}

class UserNotLoggedInException implements Exception {}