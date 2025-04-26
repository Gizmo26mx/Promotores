import 'package:flutter/material.dart';
import '../models/registro.dart';
import 'package:promotores/services/database_helper.dart';
import '../screens/registros_screen.dart'; // Importa la pantalla de registros

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: const Center(
        child: Text('¡Bienvenido a tu App Offline!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final nuevoRegistro = Registro(
              nombre: 'Nuevo ${DateTime.now().hour}:${DateTime.now().minute}',
              detalle: 'Detalle de prueba',
            );

            await DatabaseHelper.instance.insertRegistro({
              'folio': '123456',
              'fecha': DateTime.now().toIso8601String(),
              // otros campos que quieras insertar
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registro añadido')),
            );

            // Opcional: Navegar a pantalla de registros
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistrosScreen()),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}