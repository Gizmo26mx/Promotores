class Registro {
  final int? id; // Nullable para inserts nuevos
  final String nombre;
  final String detalle;
  final bool sincronizado;

  Registro({
    this.id,
    required this.nombre,
    required this.detalle,
    this.sincronizado = false,
  });

  // Convierte un Registro a Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'detalle': detalle,
      'sincronizado': sincronizado ? 1 : 0,
    };
  }

  // Crea un Registro desde Map
  factory Registro.fromMap(Map<String, dynamic> map) {
    return Registro(
      id: map['id'],
      nombre: map['nombre'],
      detalle: map['detalle'],
      sincronizado: map['sincronizado'] == 1,
    );
  }
}