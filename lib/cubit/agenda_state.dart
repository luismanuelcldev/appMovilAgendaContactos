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

  // Término de búsqueda actual
  final String busqueda;

  // Lista de contactos filtrados por búsqueda
  final List<Contacto>? contactosFiltrados;

  // Indica si el tema oscuro está activo
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

  // Constructor por defecto que crea un estado inicial vacío
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
    bool limpiarFiltro = false,
    bool limpiarError = false,
  }) {
    return AgendaState(
      contactos: contactos ?? this.contactos,
      favoritos: favoritos ?? this.favoritos,
      cargando: cargando ?? this.cargando,
      // Si limpiarError es true, establezco error a null, sino uso el nuevo valor o mantengo el anterior
      error: limpiarError ? null : (error ?? this.error),
      busqueda: busqueda ?? this.busqueda,
      // Si limpiarFiltro es true, establezco contactosFiltrados a null
      contactosFiltrados:
          limpiarFiltro
              ? null
              : (contactosFiltrados ?? this.contactosFiltrados),
      temaOscuro: temaOscuro ?? this.temaOscuro,
    );
  }

  // Verifica si un contacto está marcado como favorito
  bool esFavorito(String contactoId) {
    return favoritos.any((f) => f.contactoId == contactoId);
  }

  // Obtiene la lista de contactos que se debe mostrar (filtrados o todos)
  List<Contacto> get contactosMostrados {
    return contactosFiltrados ?? contactos;
  }

  // Obtiene la lista de contactos marcados como favoritos
  List<Contacto> get contactosFavoritos {
    return contactos.where((c) => esFavorito(c.id)).toList();
  }
}
