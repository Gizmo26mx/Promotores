import 'dart:typed_data';

class Promotor {
  final String? id; // ID opcional
  final String folio;
  final String nombre;
  final String asociacion;
  final String sector;
  final String lider;
  final String telefonoLider;
  final String vestimenta;
  final Uint8List foto;
  final bool activo;
  final String fechaRegistro;

  Promotor({
    this.id,
    required this.folio,
    required this.nombre,
    required this.asociacion,
    required this.sector,
    required this.lider,
    required this.telefonoLider,
    required this.vestimenta,
    required this.foto,
    this.activo = true,
    required this.fechaRegistro,
  });

  factory Promotor.fromMap(Map<String, dynamic> map) {
    return Promotor(
      id: map['id']?.toString(),
      folio: map['folio'],
      nombre: map['nombre'],
      asociacion: map['asociacion_id'],
      sector: map['sector'],
      lider: map['lider'],
      telefonoLider: map['telefono_lider'] as String,
      vestimenta: map['vestimenta'],
      foto: map['foto'],
      activo: map['activo'] == 1,
      fechaRegistro: map['fecha_registro'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folio': folio,
      'nombre': nombre,
      'asociacion_id': asociacion,
      'sector': sector,
      'lider': lider,
      'telefono_lider': telefonoLider,
      'vestimenta': vestimenta,
      'foto': foto,
      'activo': activo ? 1 : 0,
      'fecha_registro': fechaRegistro,
    };
  }
}
