String validateName(String name) {
  if (name.length >= 4 && name.length <= 64) {
    return null;
  }

  return "Should be at least 4 and at most 64 characters long";
}

String validateDescription(String description) {
  if (description.length >= 8 && description.length <= 256) {
    return null;
  }

  return "Should be at least 8 and at most 256 characters long";
}
