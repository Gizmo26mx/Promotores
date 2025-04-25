class Promotor {
  final String folio;
  final String nombre;
  final String asociacionId;
  final String sector;
  final String vestimenta;
  final Uint8List foto;
  final bool activo;
  final String fechaRegistro;

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
      folio: map['folio'],
      nombre: map['nombre'],
      asociacionId: map['asociacion_id'],
      sector: map['sector'],
      vestimenta: map['vestimenta'],
      foto: map['foto'],
      activo: map['activo'] == 1,
      fechaRegistro: map['fecha_registro'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'folio': folio,
      'nombre': nombre,
      'asociacion_id': asociacionId,
      'sector': sector,
      'vestimenta': vestimenta,
      'foto': foto,
      'activo': activo ? 1 : 0,
    };
  }
}