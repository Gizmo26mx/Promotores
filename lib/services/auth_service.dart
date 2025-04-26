import 'package:promotores/services/database_helper.dart';

class AuthService {
  Future<void> login(String username, String password) async {
    try {
      // Llama al método getUser de DatabaseHelper
      final user = await DatabaseHelper.instance.getUser(username, password);

      if (user != null) {
        // Verifica si la contraseña coincide con el usuario encontrado
        print('Usuario autenticado');
      } else {
        // El usuario no existe o la contraseña es incorrecta
        print('Usuario o contraseña incorrectos');
      }
    } catch (e) {
      print('Error de autenticación: $e');
    }
  }
}
