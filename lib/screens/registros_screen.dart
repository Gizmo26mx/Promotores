import 'package:flutter/material.dart';
import 'package:promotores/models/promotor_model.dart';
import 'package:promotores/services/database_helper.dart';

class RegistrosScreen extends StatefulWidget {
  const RegistrosScreen({super.key});

  @override
  State<RegistrosScreen> createState() => _RegistrosScreenState();
}

class _RegistrosScreenState extends State<RegistrosScreen> {
  List<Promotor> _promotores = [];
  List<Promotor> _promotoresFiltrados = [];
  String _filtroZona = 'Todas';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarPromotores();
    _searchController.addListener(_aplicarFiltros);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarPromotores() async {
    setState(() => _isLoading = true);
    try {
      final promotores = await DatabaseHelper.instance.getPromotores();
      setState(() {
        _promotores = promotores;
        _promotoresFiltrados = promotores;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filtrarPorZona(String? zona) {
    setState(() {
      _filtroZona = zona ?? 'Todas';
      _aplicarFiltros();
    });
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _promotoresFiltrados = _promotores.where((promotor) {
        final cumpleZona = _filtroZona == 'Todas' || promotor.zona == _filtroZona;
        final cumpleBusqueda = promotor.nombre.toLowerCase().contains(query);
        return cumpleZona && cumpleBusqueda;
      }).toList();
    });
  }

  Widget _buildItem(Promotor promotor) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          child: Text(promotor.nombre.substring(0, 1)),
        ),
        title: Text(
          promotor.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Zona: ${promotor.zona}'),
            Text(
              'Registrado: ${promotor.fechaCreacion.day}/${promotor.fechaCreacion.month}/${promotor.fechaCreacion.year}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Icon(
          promotor.sincronizado ? Icons.cloud_done : Icons.cloud_off,
          color: promotor.sincronizado ? Colors.green : Colors.orange,
        ),
      ),
    );
  }

  void _mostrarDialogoFiltros() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrar por zona'),
        content: DropdownButton<String>(
          value: _filtroZona,
          items: ['Todas', 'Zona Norte', 'Zona Sur', 'Centro', 'Occidente']
              .map((zona) => DropdownMenuItem(
            value: zona,
            child: Text(zona),
          ))
              .toList(),
          onChanged: _filtrarPorZona,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros de Promotores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _mostrarDialogoFiltros,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar promotor...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          if (_filtroZona != 'Todas' || _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_filtroZona != 'Todas')
                    Chip(
                      label: Text('Zona: $_filtroZona'),
                      onDeleted: () => _filtrarPorZona('Todas'),
                    ),
                  if (_searchController.text.isNotEmpty)
                    Chip(
                      label: Text('Búsqueda: ${_searchController.text}'),
                      onDeleted: () {
                        _searchController.clear();
                        _aplicarFiltros();
                      },
                    ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _promotoresFiltrados.isEmpty
                ? const Center(child: Text('No se encontraron resultados'))
                : RefreshIndicator(
              onRefresh: _cargarPromotores,
              child: ListView.builder(
                itemCount: _promotoresFiltrados.length,
                itemBuilder: (context, index) =>
                    _buildItem(_promotoresFiltrados[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
