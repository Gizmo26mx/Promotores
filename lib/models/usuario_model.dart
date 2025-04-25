class Usuario {
  final String id;
  final String username;
  final String passwordHash;
  final String rol;
  final String fechaCreacion;

  Usuario({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.rol,
    required this.fechaCreacion,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      username: map['username'],
      passwordHash: map['password_hash'],
      rol: map['rol'],
      fechaCreacion: map['fecha_creacion'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password_hash': passwordHash,
      'rol': rol,
    };
  }
}