import 'package:flutter/material.dart';
import 'package:promotores/services/database_helper.dart';
import 'promotor_screen.dart';
import 'package:promotores/models/promotor_model.dart';  // Asegúrate de importar el modelo Promotor

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _errorMessage;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final user = await DatabaseHelper.instance.getUser(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        // Obtener el promotor correspondiente
        final promotor = await DatabaseHelper.instance.getPromotorByFolio(user['folio']);

        if (promotor != null) {
          // Navegar a PromotorScreen con el promotor como parámetro
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PromotorScreen(promotor: promotor)),
          );
        } else {
          setState(() {
            _errorMessage = 'Promotor no encontrado';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Usuario o contraseña incorrectos';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Usuario'),
                validator: (value) => value!.isEmpty ? 'Ingrese usuario' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Ingrese contraseña' : null,
              ),
              SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Ingresar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
