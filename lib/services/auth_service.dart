import 'package:promotores/models/usuario_model.dart';
import 'package:promotores/services/database_helper.dart';

class AuthService {
  final DatabaseHelper _dbHelper;

  AuthService(this._dbHelper);

  // 1. Método para login
  Future<Usuario?> login(String username, String password) async {
    try {
      final userMap = await _dbHelper.getUser(username, password);
      if (userMap != null) {
        return Usuario.fromMap(userMap);
      }
      return null;
    } catch (e) {
      print('Error en AuthService.login: $e');
      return null;
    }
  }

  // 2. Método para registro
  Future<bool> register(Usuario usuario) async {
    try {
      final result = await _dbHelper.insertUsuario(usuario.toMap());
      return result > 0;
    } catch (e) {
      print('Error en AuthService.register: $e');
      return false;
    }
  }

  // 3. Método para verificar si usuario existe
  Future<bool> userExists(String username) async {
    try {
      // Implementar este método en DatabaseHelper
      final user = await _dbHelper.getUserByUsername(username);
      return user != null;
    } catch (e) {
      print('Error en AuthService.userExists: $e');
      return false;
    }
  }

  // 4. Método para cambiar contraseña
  Future<bool> changePassword(String username, String newPassword) async {
    try {
      // Implementar este método en DatabaseHelper
      final rowsAffected = await _dbHelper.updatePassword(username, newPassword);
      return rowsAffected > 0;
    } catch (e) {
      print('Error en AuthService.changePassword: $e');
      return false;
    }
  }
}