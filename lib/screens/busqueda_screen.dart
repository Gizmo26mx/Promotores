import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'package:promotores/models/promotor_model.dart';
import 'dart:typed_data';
import 'package:promotores/screens/promotor_screen.dart';  // Importa la pantalla de detalle

class BusquedaScreen extends StatefulWidget {
  const BusquedaScreen({Key? key}) : super(key: key);

  @override
  _BusquedaScreenState createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  final TextEditingController _folioController = TextEditingController();
  Promotor? _promotor;
  bool _isLoading = false;

  Future<void> _buscarPromotor() async {
    setState(() => _isLoading = true);

    // Buscar el promotor por el folio
    final promotor = await DatabaseHelper.instance
        .getPromotorByFolio(_folioController.text.trim());

    setState(() {
      _promotor = promotor;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validar Promotor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _folioController,
              decoration: InputDecoration(
                labelText: 'Folio de credencial',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarPromotor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _promotor != null
                ? _buildPromotorCard(_promotor!)
                : const Text('Ingrese un folio válido'),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotorCard(Promotor promotor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Si el promotor tiene foto, mostramos una imagen, de lo contrario, mostramos un avatar por defecto
            CircleAvatar(
              radius: 50,
              backgroundImage: promotor.foto != null
                  ? MemoryImage(Uint8List.fromList(promotor.foto!)) // Convertir List<int> a Uint8List
                  : const AssetImage('assets/images/avatar_default.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            // Mostramos los detalles del promotor
            Text('${promotor.nombre} ${promotor.apellidos}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Número de Asociación: ${promotor.numeroAsociacion}'),
            Text('Sector: ${promotor.sector}'),
            // Añadimos la información de la asociación (nombre del líder, teléfono líder, etc.)
            FutureBuilder<Map<String, dynamic>?>(
              future: DatabaseHelper.instance.getAsociacionByNumero(promotor.numeroAsociacion),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  var asociacion = snapshot.data;
                  return Column(
                    children: [
                      Text('Asociación: ${asociacion?['nombre']}'),
                      Text('Líder: ${asociacion?['lider']}'),
                      Text('Teléfono líder: ${asociacion?['telefono_lider']}'),
                    ],
                  );
                } else {
                  return const Text('No se encontró la asociación');
                }
              },
            ),
            const SizedBox(height: 8),
            Text('Vestimenta: ${promotor.vestimenta}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PromotorScreen(promotor: promotor),
                  ),
                );
              },
              child: const Text('Ver Detalles'),
            ),
          ],
        ),
      ),
    );
  }
}
