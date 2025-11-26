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

  // Carga todos los contactos y favoritos desde los repositorios y actualiza el estado de la aplicación
  Future<void> cargarContactos() async {
    // Emito estado de carga
    emit(state.copyWith(cargando: true));
    try {
      // Obtengo datos de ambos repositorios
      final contactos = await contactoRepository.obtenerContactos();
      final favoritos = favoritoRepository.obtenerFavoritos();

      // Actualizo el estado con los nuevos datos y limpio errores previos
      emit(
        state.copyWith(
          contactos: contactos,
          favoritos: favoritos,
          cargando: false,
          limpiarError: true,
        ),
      );
    } catch (e) {
      // En caso de error, actualizo el estado con el mensaje de error
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  /// Agrega un nuevo contacto al repositorio y recarga la lista de contactos para actualizar la UI
  Future<void> agregarContacto(Contacto contacto) async {
    emit(state.copyWith(cargando: true));
    try {
      await contactoRepository.agregarContacto(contacto);
      // Recargo la lista completa para asegurar consistencia
      await cargarContactos();
    } catch (e) {
      // En caso de error, actualizo el estado con el mensaje
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  // Actualiza un contacto existente
  Future<void> actualizarContacto(Contacto contacto) async {
    emit(state.copyWith(cargando: true));
    try {
      // Verifico si es un contacto local antes de editar
      if (esContactoLocal(contacto.id)) {
        await contactoRepository.actualizarContacto(contacto);
        await cargarContactos();
      } else {
        // Emito error si se intenta editar un contacto de la API
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
        // Si es favorito, primero lo elimino de la lista de favoritos
        if (state.esFavorito(id)) {
          await favoritoRepository.eliminarFavorito(id);
        }
        // Elimino el contacto y recargo la lista
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
      // Si la búsqueda está vacía, limpio los filtros y errores
      emit(
        state.copyWith(busqueda: '', limpiarFiltro: true, limpiarError: true),
      );
      return;
    }

    final queryLower = query.toLowerCase();
    // Filtro los contactos que coincidan con la búsqueda en nombre, teléfono o email
    final contactosFiltrados =
        state.contactos.where((contacto) {
          return contacto.nombreCompleto.toLowerCase().contains(queryLower) ||
              contacto.telefono.toLowerCase().contains(queryLower) ||
              contacto.email.toLowerCase().contains(queryLower);
        }).toList();

    // Actualizo el estado con los resultados de la búsqueda
    emit(
      state.copyWith(
        busqueda: query,
        contactosFiltrados: contactosFiltrados,
        error:
            contactosFiltrados.isEmpty ? 'No se encontraron contactos' : null,
        limpiarError: contactosFiltrados.isNotEmpty,
      ),
    );
  }

  // Alterna el estado de favorito de un contacto
  Future<void> toggleFavorito(Contacto contacto) async {
    emit(state.copyWith(cargando: true));
    try {
      if (state.esFavorito(contacto.id)) {
        // Si ya es favorito, lo elimino
        await favoritoRepository.eliminarFavorito(contacto.id);
      } else {
        // Si no es favorito, lo agrego
        await favoritoRepository.agregarFavorito(contacto.id);
      }
      // Actualizo la lista de favoritos en el estado
      final favoritos = favoritoRepository.obtenerFavoritos();
      emit(
        state.copyWith(
          favoritos: favoritos,
          cargando: false,
          limpiarError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  /// Elimina todos los contactos de la lista de favoritos
  Future<void> limpiarFavoritos() async {
    emit(state.copyWith(cargando: true));
    try {
      // Elimino todos los favoritos del repositorio
      await favoritoRepository.limpiarFavoritos();
      // Actualizo la lista de favoritos (ahora vacía)
      final favoritos = favoritoRepository.obtenerFavoritos();
      emit(
        state.copyWith(
          favoritos: favoritos,
          cargando: false,
          limpiarError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  /// Actualiza el estado del tema de la aplicación
  void cambiarTema(bool temaOscuro) {
    emit(state.copyWith(temaOscuro: temaOscuro));
  }
}
