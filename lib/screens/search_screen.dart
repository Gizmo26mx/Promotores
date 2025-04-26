import 'package:flutter/material.dart';
import 'package:promotores/models/promotor_model.dart'; //
import 'package:promotores/services/database_helper.dart';

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
              backgroundImage: MemoryImage(promotor.foto),
            ),
            const SizedBox(height: 16),
            Text(
              promotor.nombre,
              style: Theme.of(context).textTheme.headline6,
            ),
            const Divider(),
            _buildInfoRow('Folio', promotor.folio),
            _buildInfoRow('Asociación', promotor.asociacion),
            _buildInfoRow('Sector', promotor.sector),
            _buildInfoRow('Líder', promotor.lider),
            _buildInfoRow('Teléfono Líder', promotor.telefonoLider),
            _buildInfoRow('Vestimenta', promotor.vestimenta),
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