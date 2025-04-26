import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'package:promotores/models/promotor_model.dart';

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
            CircleAvatar(
              radius: 50,
              backgroundImage: MemoryImage(promotor.foto),
            ),
            const SizedBox(height: 16),
            Text(promotor.nombre, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Asociación: ${promotor.asociacion}'),
            Text('Sector: ${promotor.sector}'),
            Text('Líder: ${promotor.lider}'),
            Text('Teléfono líder: ${promotor.telefonoLider}'),
            Text('Vestimenta: ${promotor.vestimenta}'),
          ],
        ),
      ),
    );
  }
}