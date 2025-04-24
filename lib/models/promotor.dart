class Promotor {
  final int? id; // Nullable para inserts nuevos
  final String nombre;
  final String zona;
  final bool sincronizado;
  final DateTime fechaCreacion;

  Promotor({
    this.id,
    required this.nombre,
    required this.zona,
    this.sincronizado = false,
    required this.fechaCreacion,
  });

  // Convierte un Promotor a Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'zona': zona,
      'sincronizado': sincronizado ? 1 : 0,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  // Crea un Promotor desde Map (desde SQLite)
  factory Promotor.fromMap(Map<String, dynamic> map) {
    return Promotor(
      id: map['id'] as int,
      nombre: map['nombre'] as String,
      zona: map['zona'] as String,
      sincronizado: map['sincronizado'] == 1,
      fechaCreacion: DateTime.parse(map['fecha_creacion'] as String),
    );
  }

  // Método para copiar el promotor con nuevos valores
  Promotor copyWith({
    int? id,
    String? nombre,
    String? zona,
    bool? sincronizado,
    DateTime? fechaCreacion,
  }) {
    return Promotor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      zona: zona ?? this.zona,
      sincronizado: sincronizado ?? this.sincronizado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  @override
  String toString() {
    return 'Promotor{id: $id, nombre: $nombre, zona: $zona, sincronizado: $sincronizado, fechaCreacion: $fechaCreacion}';
  }

  // Para comparar promotores
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Promotor &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              nombre == other.nombre &&
              zona == other.zona;

  @override
  int get hashCode => Object.hash(id, nombre, zona);
}