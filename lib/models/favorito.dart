class Favorito {
  final String contactoId;
  final DateTime agregadoEn;

  Favorito({required this.contactoId, required this.agregadoEn});

  Map<String, dynamic> toJson() => {
    'contactoId': contactoId,

    'agregadoEn': agregadoEn.toIso8601String(),
  };

  factory Favorito.fromJson(Map<String, dynamic> json) => Favorito(
    contactoId: json['contactoId'],

    agregadoEn: DateTime.parse(json['agregadoEn']),
  );
}
