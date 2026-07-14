class Validators {
  Validators._();

  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static String? required(String? value, {String message = 'Este campo es obligatorio'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  static String? minLength(String? value, int length) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (value!.trim().length < length) {
      return 'Debe tener al menos $length caracteres';
    }
    return null;
  }
}
