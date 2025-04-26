import 'package:flutter/material.dart';
import 'package:promotores/services/database_helper.dart';
import 'login_screen.dart';

class PromotorScreen extends StatefulWidget {
  @override
  _PromotorScreenState createState() => _PromotorScreenState();
}

class _PromotorScreenState extends State<PromotorScreen> {
  final TextEditingController _folioController = TextEditingController();
  Map<String, dynamic>? _promotor;
  String? _mensajeError;

  void _buscarPromotor() async {
    final folio = _folioController.text.trim();
    if (folio.isEmpty) return;

    try {
      final result = await DatabaseHelper.instance.getPromotorByNumero(folio);

      setState(() {
        _promotor = result;
        _mensajeError = result == null ? 'No se encontró promotor' : null;
      });
    } catch (e) {
      setState(() {
        _mensajeError = 'Error al buscar promotor';
      });
      debugPrint('Error al buscar promotor: $e');
    }
  }

  void _cerrarSesion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Promotor'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _folioController,
              decoration: InputDecoration(
                labelText: 'Número de promotor',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _buscarPromotor,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_mensajeError != null)
              Text(_mensajeError!, style: TextStyle(color: Colors.red)),
            if (_promotor != null)
              Card(
                elevation: 4,
                margin: EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre: ${_promotor!['nombre']}'),
                      Text('Número: ${_promotor!['numero_promotor']}'),
                      Text('Empresa: ${_promotor!['empresa']}'),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}