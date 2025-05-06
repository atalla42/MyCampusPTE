// Validation Function for teh required Fields


String? validateRequiredField(String? value) {
  if (value == null || value.isEmpty) {
    return "Required";
  }
  return null;
}

String? passWordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Required";
  }
  if (value.length < 7) {
    return "Password Lenght Must be Greater than 7";
  }
  return null;
}
