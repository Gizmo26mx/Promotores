import 'package:flutter/material.dart';
import 'package:promotores/models/promotor_model.dart';
import 'package:promotores/services/database_helper.dart';
import 'package:promotores/screens/promotor_screen.dart'; // Importa la pantalla de detalle

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _folioController = TextEditingController();
  Promotor? _promotor;
  bool _isLoading = false;
  String _searchError = '';

  Future<void> _searchPromotor() async {
    final folio = _folioController.text.trim();
    if (folio.isEmpty) {
      setState(() => _searchError = 'Ingrese un folio válido');
      return;
    }

    setState(() {
      _isLoading = true;
      _promotor = null;
      _searchError = '';
    });

    try {
      final promotor = await DatabaseHelper.instance.getPromotorByFolio(folio);

      if (promotor != null) {
        setState(() => _promotor = promotor);
      } else {
        setState(() => _searchError = 'Promotor no encontrado');
      }
    } catch (e) {
      setState(() => _searchError = 'Error en la búsqueda: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar Promotor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _folioController,
              decoration: InputDecoration(
                labelText: 'Folio de la credencial',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchPromotor,
                ),
                errorText: _searchError.isNotEmpty ? _searchError : null,
              ),
              onSubmitted: (_) => _searchPromotor(),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _promotor != null
                ? _buildPromotorCard(_promotor!)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotorCard(Promotor promotor) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: promotor.foto != null
                  ? MemoryImage(Uint8List.fromList(promotor.foto!)) // Conversión de List<int> a Uint8List
                  : const AssetImage('assets/images/avatar_default.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              '${promotor.nombre} ${promotor.apellidos}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildInfoRow('Folio', promotor.folio),
            _buildInfoRow('Asociación', promotor.numeroAsociacion.toString()),
            _buildInfoRow('Asociación', promotor.numeroAsociacion?.toString() ?? 'No disponible'),
            _buildInfoRow('Sector', promotor.sector ?? 'No disponible'),
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
                      const Divider(),
                      _buildInfoRow('Líder', asociacion?['lider'] ?? 'No disponible'),
                      _buildInfoRow('Teléfono Líder', asociacion?['telefono_lider'] ?? 'No disponible'),
                    ],
                  );
                } else {
                  return const Text('No se encontró la asociación');
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de detalle del promotor
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _folioController.dispose();
    super.dispose();
  }
}
