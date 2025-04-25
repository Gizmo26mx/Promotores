class Asociacion {
  final String id;
  final String nombre;
  final String lider;
  final String telefonoLider;
  final String? descripcion;
  final Uint8List? logo;
  final String fechaRegistro;

  Asociacion({
    required this.id,
    required this.nombre,
    required this.lider,
    required this.telefonoLider,
    this.descripcion,
    this.logo,
    required this.fechaRegistro,
  });

  factory Asociacion.fromMap(Map<String, dynamic> map) {
    return Asociacion(
      id: map['id'],
      nombre: map['nombre'],
      lider: map['lider'],
      telefonoLider: map['telefono_lider'],
      descripcion: map['descripcion'],
      logo: map['logo'],
      fechaRegistro: map['fecha_registro'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'lider': lider,
      'telefono_lider': telefonoLider,
      'descripcion': descripcion,
      'logo': logo,
    };
  }
}