// Clase que representa un contacto en la agenda
class Contacto {
  // Identificador único del contacto
  final String id;
  // Nombre(s) del contacto
  final String nombre;
  // Apellido(s) del contacto
  final String apellido;
  // Direccion de correo electronico
  final String email;
  // Numero de telefono
  final String telefono;
  // URL de la imagen de perfil
  final String imagenUrl;

  // Fecha de nacimiento del contacto
  final DateTime fechaNacimiento;

  // Direccion fisica del contacto
  final String direccion;

  // Constructor principal de Contacto
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

  // Constructor por defecto para crear un nuevo contacto
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

  // Crea una copia del contacto con campos opcionales actualizados
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

  // Crea una instancia de Contacto a partir de un Map JSON
  factory Contacto.fromJson(Map<String, dynamic> json) {
    return Contacto(
      id:
          // Intenta obtener el ID de diferentes fuentes
          json['login']?['uuid'] ??
          json['id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      // Maneja el nombre tanto de la API como del formato local
      nombre: json['name']?['first'] ?? json['nombre'] ?? '',
      apellido: json['name']?['last'] ?? json['apellido'] ?? '',
      email: json['email'] ?? '',
      telefono: json['phone'] ?? json['telefono'] ?? 'No disponible',
      imagenUrl: json['picture']?['large'] ?? json['imagenUrl'] ?? '',
      // Parsea la fecha de nacimiento de diferentes formatos
      fechaNacimiento: DateTime.parse(
        json['dob']?['date'] ??
            json['fechaNacimiento'] ??
            DateTime.now().toString(),
      ),
      // Construye la dirección a partir de componentes o usa el valor directo
      direccion:
          json['direccion'] ??
          '${json['location']?['street']?['number'] ?? ''} '
              '${json['location']?['street']?['name'] ?? ''}, '
              '${json['location']?['city'] ?? ''}, '
              '${json['location']?['country'] ?? ''}',
    );
  }

  // Convierte el contacto a un formato JSON para almacenamiento
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
