// Importaciones necesarias para el manejo de estado con BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/contacto.dart';
import '../models/favorito.dart';

// Repositorios para el acceso a datos
import '../repositories/contacto_repository.dart';
import '../repositories/favorito_repository.dart';

// Contiene la definición del estado
part 'agenda_state.dart';

/// Cubit para manejar el estado de la agenda de contactos
class AgendaCubit extends Cubit<AgendaState> {
  /// Repositorio para operaciones con contactos
  final ContactoRepository contactoRepository;

  /// Repositorio para operaciones con favoritos
  final FavoritoRepository favoritoRepository;

  /// Constructor que inicializa el Cubit con los repositorios necesarios
  AgendaCubit({
    required this.contactoRepository,
    required this.favoritoRepository,
  }) : super(AgendaState.init());

  // Verifica si un contacto es local (no proviene de la API)

  bool esContactoLocal(String id) {
    return !id.startsWith('api_');
  }

  // Carga todos los contactos y favoritos desde los repositorios y actualiza el estado de la aplicacion
  Future<void> cargarContactos() async {
    emit(state.copyWith(cargando: true));
    try {
      final contactos = await contactoRepository.obtenerContactos();
      final favoritos = favoritoRepository.obtenerFavoritos();
      // Actualiza el estado con los nuevos datos
      emit(
        state.copyWith(
          contactos: contactos,
          favoritos: favoritos,
          cargando: false,
          error: null,
        ),
      );
    } catch (e) {
      // En caso de error, actualiza el estado con el mensaje de error
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  /// Agrega un nuevo contacto al repositorio y recarga la lista de contactos para actualizar la UI
  Future<void> agregarContacto(Contacto contacto) async {
    emit(state.copyWith(cargando: true));
    try {
      await contactoRepository.agregarContacto(contacto);
      await cargarContactos();
    } catch (e) {
      // En caso de error, actualiza el estado con el mensaje
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  Future<void> actualizarContacto(Contacto contacto) async {
    emit(state.copyWith(cargando: true));
    try {
      if (esContactoLocal(contacto.id)) {
        await contactoRepository.actualizarContacto(contacto);
        await cargarContactos();
      } else {
        emit(
          state.copyWith(
            error: 'No se pueden editar contactos de la API',
            cargando: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  /// Elimina un contacto por su ID si es local y si el contacto es un favorito, también lo elimina de favoritos
  Future<void> eliminarContacto(String id) async {
    emit(state.copyWith(cargando: true));
    try {
      if (esContactoLocal(id)) {
        // Si es favorito, primero lo elimina de favoritos
        if (state.esFavorito(id)) {
          await favoritoRepository.eliminarFavorito(id);
        }
        // Elimina el contacto y recarga la lista
        await contactoRepository.eliminarContacto(id);
        await cargarContactos();
      } else {
        // Error si se intenta eliminar un contacto de la API
        emit(
          state.copyWith(
            error: 'No se pueden eliminar contactos de la API',
            cargando: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  /// Realiza una búsqueda en los contactos basada en un texto
  void buscarContactos(String query) {
    if (query.isEmpty) {
      // Si la busqueda esta vacia, limpia los filtros
      emit(state.copyWith(busqueda: '', contactosFiltrados: null, error: null));
      return;
    }

    final queryLower = query.toLowerCase();
    // Filtra los contactos que coincidan con la búsqueda
    final contactosFiltrados =
        state.contactos.where((contacto) {
          return contacto.nombreCompleto.toLowerCase().contains(queryLower) ||
              contacto.telefono.toLowerCase().contains(queryLower) ||
              contacto.email.toLowerCase().contains(queryLower);
        }).toList();

    // Actualiza el estado con los resultados de la búsqueda
    emit(
      state.copyWith(
        busqueda: query,
        contactosFiltrados: contactosFiltrados,
        error:
            contactosFiltrados.isEmpty ? 'No se encontraron contactos' : null,
      ),
    );
  }

  // Si ya es favorito lo elimina, si no lo es lo agrega
  Future<void> toggleFavorito(Contacto contacto) async {
    emit(state.copyWith(cargando: true));
    try {
      if (state.esFavorito(contacto.id)) {
        // Si ya es favorito, lo elimina
        await favoritoRepository.eliminarFavorito(contacto.id);
      } else {
        // Si no es favorito, lo agrega
        await favoritoRepository.agregarFavorito(contacto.id);
      }
      // Actualiza la lista de favoritos
      final favoritos = favoritoRepository.obtenerFavoritos();
      emit(state.copyWith(favoritos: favoritos, cargando: false, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  /// Elimina todos los contactos de la lista de favoritos
  Future<void> limpiarFavoritos() async {
    emit(state.copyWith(cargando: true));
    try {
      // Elimina todos los favoritos
      await favoritoRepository.limpiarFavoritos();
      // Actualiza la lista de favoritos (ahora vacía)
      final favoritos = favoritoRepository.obtenerFavoritos();
      emit(state.copyWith(favoritos: favoritos, cargando: false, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  /// Actualiza el estado del tema de la aplicacion
  void cambiarTema(bool temaOscuro) {
    emit(state.copyWith(temaOscuro: temaOscuro));
  }
}
