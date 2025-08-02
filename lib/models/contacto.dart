class Contacto {
  final String id;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String imagenUrl;
  final DateTime fechaNacimiento;
  final String direccion;

  Contacto({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.imagenUrl,
    required this.fechaNacimiento,
    required this.direccion,
  });

  factory Contacto.nuevo({
    required String nombre,
    required String apellido,
    required String email,
    required String telefono,
    required String imagenUrl,
    required DateTime fechaNacimiento,
    required String direccion,
  }) {
    return Contacto(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre,
      apellido: apellido,
      email: email,
      telefono: telefono,
      imagenUrl: imagenUrl,
      fechaNacimiento: fechaNacimiento,
      direccion: direccion,
    );
  }

  Contacto copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? email,
    String? telefono,
    String? imagenUrl,
    DateTime? fechaNacimiento,
    String? direccion,
  }) {
    return Contacto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      direccion: direccion ?? this.direccion,
    );
  }

  factory Contacto.fromJson(Map<String, dynamic> json) {
    return Contacto(
      id:
          json['login']?['uuid'] ??
          json['id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: json['name']?['first'] ?? json['nombre'] ?? '',
      apellido: json['name']?['last'] ?? json['apellido'] ?? '',
      email: json['email'] ?? '',
      telefono: json['phone'] ?? json['telefono'] ?? 'No disponible',
      imagenUrl: json['picture']?['large'] ?? json['imagenUrl'] ?? '',
      fechaNacimiento: DateTime.parse(
        json['dob']?['date'] ??
            json['fechaNacimiento'] ??
            DateTime.now().toString(),
      ),
      direccion:
          json['direccion'] ??
          '${json['location']?['street']?['number'] ?? ''} '
              '${json['location']?['street']?['name'] ?? ''}, '
              '${json['location']?['city'] ?? ''}, '
              '${json['location']?['country'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'imagenUrl': imagenUrl,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'direccion': direccion,
    };
  }

  String get nombreCompleto => '$nombre $apellido';
}
