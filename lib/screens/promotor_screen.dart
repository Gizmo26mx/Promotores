import 'package:flutter/material.dart';
import 'package:promotores/models/promotor_model.dart';
import 'package:promotores/services/database_helper.dart';
import 'dart:typed_data';

class PromotorScreen extends StatelessWidget {
  final Promotor promotor;

  const PromotorScreen({Key? key, required this.promotor}) : super(key: key);

  Future<Map<String, dynamic>?> _getAsociacionInfo(String numeroAsociacion) async {
    // Ya que numeroAsociacion es String, lo pasamos directo
    return await DatabaseHelper.instance.getAsociacionByNumero(numeroAsociacion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Promotor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getAsociacionInfo(promotor.numeroAsociacion),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final asociacion = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: promotor.foto != null
                        ? MemoryImage(Uint8List.fromList(promotor.foto!))
                        : const AssetImage('assets/images/avatar_default.png') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${promotor.nombre} ${promotor.apellidos}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('Folio: ${promotor.folio}'),
                const SizedBox(height: 8),
                Text('Asociación: ${promotor.numeroAsociacion}'),
                const SizedBox(height: 8),
                Text('Sector: ${promotor.sector ?? 'No disponible'}'),
                const SizedBox(height: 8),
                Text('Líder: ${asociacion?['lider'] ?? 'No disponible'}'),
                Text('Teléfono líder: ${asociacion?['telefono_lider'] ?? 'No disponible'}'),
                const SizedBox(height: 8),
                Text('Vestimenta: ${asociacion?['vestimenta'] ?? 'No disponible'}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
