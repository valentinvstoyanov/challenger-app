String validateName(String name) {
  if (name.length >= 4 && name.length <= 64) {
    return null;
  }

  return "4 to 64 characters expected";
}

String validateDescription(String description) {
  if (description.length >= 8 && description.length <= 256) {
    return null;
  }

  return "8 to 256 characters expected";
}
