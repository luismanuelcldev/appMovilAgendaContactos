part of 'agenda_cubit.dart';

class AgendaState {
  final List<Contacto> contactos;
  final List<Favorito> favoritos;
  final bool cargando;
  final String? error;
  final String busqueda;
  final List<Contacto>? contactosFiltrados;
  final bool temaOscuro;

  AgendaState({
    required this.contactos,
    required this.favoritos,
    required this.cargando,
    this.error,
    this.busqueda = '',
    this.contactosFiltrados,
    this.temaOscuro = false,
  });

  factory AgendaState.init() =>
      AgendaState(contactos: [], favoritos: [], cargando: false);

  AgendaState copyWith({
    List<Contacto>? contactos,
    List<Favorito>? favoritos,
    bool? cargando,
    String? error,
    String? busqueda,
    List<Contacto>? contactosFiltrados,
    bool? temaOscuro,
  }) {
    return AgendaState(
      contactos: contactos ?? this.contactos,
      favoritos: favoritos ?? this.favoritos,
      cargando: cargando ?? this.cargando,
      error: error ?? this.error,
      busqueda: busqueda ?? this.busqueda,
      contactosFiltrados: contactosFiltrados ?? this.contactosFiltrados,
      temaOscuro: temaOscuro ?? this.temaOscuro,
    );
  }

  bool esFavorito(String contactoId) {
    return favoritos.any((f) => f.contactoId == contactoId);
  }

  List<Contacto> get contactosMostrados {
    return contactosFiltrados ?? contactos;
  }

  List<Contacto> get contactosFavoritos {
    return contactos.where((c) => esFavorito(c.id)).toList();
  }
}
