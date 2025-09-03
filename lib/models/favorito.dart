class Favorito {
  // Identificador unico del contacto asociado a este favorito.
  final String contactoId;

  // Fecha y hora en que se agrego este favorito.
  final DateTime agregadoEn;

  // Constructor para crear una instancia de Favorito.
  Favorito({required this.contactoId, required this.agregadoEn});

  // Convierto la instancia de Favorito a un mapa JSON.
  Map<String, dynamic> toJson() => {
    'contactoId': contactoId,

    'agregadoEn': agregadoEn.toIso8601String(),
  };

  // Creo una instancia de Favorito a partir de un mapa JSON.
  factory Favorito.fromJson(Map<String, dynamic> json) => Favorito(
    contactoId: json['contactoId'],

    agregadoEn: DateTime.parse(json['agregadoEn']),
  );
}
