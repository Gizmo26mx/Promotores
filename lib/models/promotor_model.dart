class Promotor {
  final String folio;
  final String nombre;
  final String asociacionId;
  final String sector;
  final String vestimenta;
  final Uint8List foto;
  final bool activo;
  final String fechaRegistro;
  final String? id;  // Añadir ID para SQLite
  final String asociacionId; // Cambiar de 'asociacion' a 'asociacionId'

  Promotor({
    required this.folio,
    required this.nombre,
    required this.asociacionId,
    required this.sector,
    required this.vestimenta,
    required this.foto,
    this.activo = true,
    required this.fechaRegistro,
  });

  factory Promotor.fromMap(Map<String, dynamic> map) {
    return Promotor(
      id: map['id'],
      folio: map['folio'],
      nombre: map['nombre'],
      asociacionId: map['asociacion_id'],
      sector: map['sector'],
      vestimenta: map['vestimenta'],
      foto: map['foto'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folio': folio,
      'nombre': nombre,
      'asociacion_id': asociacionId, // Relación con tabla asociaciones
      'sector': sector,
      'vestimenta': vestimenta,
      'foto': foto,
    };
  }
}