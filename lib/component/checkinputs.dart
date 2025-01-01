String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
RegExp regExpEmail = RegExp(emailPattern);

bool isValidEmail(String email) {
  return regExpEmail.hasMatch(email);
}

String usernamePattern = r'^(?=.*[a-zA-Z])[a-zA-Z0-9_-]+$';
RegExp regExpName = RegExp(usernamePattern);

bool isValidUsername(String username) {
  return regExpName.hasMatch(username);
}

String passwordPattern = r'^.{8,}$';
RegExp regExpPass = RegExp(passwordPattern);

bool isValidPassword(String password) {
  return regExpPass.hasMatch(password);
}
