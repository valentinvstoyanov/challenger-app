String validateEmail(String email) {
  if (RegExp(r"^[a-zA-Z0-9\.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$").hasMatch(email)) {
    return null;
  }

  return "Doesn't match email criteria";
}

String validatePassword(String password) {
  if (RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,64}$").hasMatch(password)) {
    return null;
  }

  return "At least 6 characters, 1 letter and 1 digit";
}

String validateName(String name) {
  if (RegExp(r"^([a-zA-Z]+|[a-zA-Z]+\s{1}[a-zA-Z]{1,}|[a-zA-Z]+\s{1}[a-zA-Z]{3,}\s{1}[a-zA-Z]{1,})$").hasMatch(name)) {
    return null;
  }

  return "Up to 3 space separated names";
}

String validateUsername(String username) {
  if (RegExp(r"^[a-zA-z0-9-._]{4,64}$").hasMatch(username)) {
    return null;
  }

  return "At least 4 letters, digits, '-', '.' or '_'";
}