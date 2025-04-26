import 'package:promotores/services/database_helper.dart';

class AuthService {
  Future<void> login(String username, String password) async {
    try {
      // Llama al metodo getUserByUsername de DatabaseHelper
      final user = await DatabaseHelper.instance.getUserByUsername(username);

      if (user != null) {
        // Verifica si la contraseña coincide con el usuario encontrado
        if (user['password'] == password) {
          // El login es exitoso
          print('Usuario autenticado');
        } else {
          // Contraseña incorrecta
          print('Contraseña incorrecta');
        }
      } else {
        // El usuario no existe
        print('Usuario no encontrado');
      }
    } catch (e) {
      print('Error de autenticación: $e');
    }
  }
}
