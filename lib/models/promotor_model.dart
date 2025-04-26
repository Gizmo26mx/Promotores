class Promotor {
  final int? id;
  final String folio;
  final String nombre;
  final String apellidos;
  final List<int>? foto; // La foto sigue como bytes opcionales
  final String numeroAsociacion; // Relacionado con 'asociaciones'
  final String? sector;
  final String? vestimenta;

  // Constructor
  Promotor({
    this.id,
    required this.folio,
    required this.nombre,
    required this.apellidos,
    this.foto,
    required this.numeroAsociacion,
    this.sector,
    this.vestimenta,
  });

  // Metodo para convertir de Map a Promotor
  factory Promotor.fromMap(Map<String, dynamic> map) {
    return Promotor(
      id: map['id'],
      folio: map['folio'],
      nombre: map['nombre'],
      apellidos: map['apellidos'],
      foto: map['foto'] != null ? List<int>.from(map['foto']) : null, // Convertir bytes a List<int>
      numeroAsociacion: map['numero_asociacion'],
      sector: map['sector'],
      vestimenta: map['vestimenta'],

    );
  }

  // Metodo para convertir Promotor a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folio': folio,
      'nombre': nombre,
      'apellidos': apellidos,
      'foto': foto, // Guardamos la foto como List<int>
      'numero_asociacion': numeroAsociacion,
      'sector': sector,
      'vestimenta': vestimenta,
    };
  }
}
