part of 'agenda_cubit.dart';

// Estado de la agenda de contactos
class AgendaState {
  // Lista completa de contactos disponibles
  final List<Contacto> contactos;

  // Lista de IDs de contactos marcados como favoritos
  final List<Favorito> favoritos;

  // Indica si hay alguna operación en progreso
  final bool cargando;

  // Mensaje de error si existe alguno
  final String? error;

  // Termino de busqueda actual
  final String busqueda;

  // Lista de contactos filtrados por busqueda
  final List<Contacto>? contactosFiltrados;

  // Indica si el tema oscuro esta activo
  final bool temaOscuro;

  // Constructor principal del estado
  AgendaState({
    required this.contactos,
    required this.favoritos,
    required this.cargando,
    this.error,
    this.busqueda = '',
    this.contactosFiltrados,
    this.temaOscuro = false,
  });

  // Constructor por defecto que crea un estado inicial
  factory AgendaState.init() =>
      AgendaState(contactos: [], favoritos: [], cargando: false);

  // Crea una nueva instancia del estado con los campos actualizados
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

  // Verifica si un contacto esta marcado como favorito
  bool esFavorito(String contactoId) {
    return favoritos.any((f) => f.contactoId == contactoId);
  }

  // Obtiene la lista de contactos que se debe mostrar
  List<Contacto> get contactosMostrados {
    return contactosFiltrados ?? contactos;
  }

  // Obtiene la lista de contactos marcados como favoritos
  List<Contacto> get contactosFavoritos {
    return contactos.where((c) => esFavorito(c.id)).toList();
  }
}
