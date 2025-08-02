import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/contacto.dart';
import '../models/favorito.dart';
import '../repositories/contacto_repository.dart';
import '../repositories/favorito_repository.dart';

part 'agenda_state.dart';

class AgendaCubit extends Cubit<AgendaState> {
  final ContactoRepository contactoRepository;
  final FavoritoRepository favoritoRepository;

  AgendaCubit({
    required this.contactoRepository,
    required this.favoritoRepository,
  }) : super(AgendaState.init());

  bool esContactoLocal(String id) {
    return !id.startsWith('api_');
  }

  Future<void> cargarContactos() async {
    emit(state.copyWith(cargando: true));
    try {
      final contactos = await contactoRepository.obtenerContactos();
      final favoritos = favoritoRepository.obtenerFavoritos();
      emit(
        state.copyWith(
          contactos: contactos,
          favoritos: favoritos,
          cargando: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  Future<void> agregarContacto(Contacto contacto) async {
    emit(state.copyWith(cargando: true));
    try {
      await contactoRepository.agregarContacto(contacto);
      await cargarContactos();
    } catch (e) {
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

  Future<void> eliminarContacto(String id) async {
    emit(state.copyWith(cargando: true));
    try {
      if (esContactoLocal(id)) {
        if (state.esFavorito(id)) {
          await favoritoRepository.eliminarFavorito(id);
        }
        await contactoRepository.eliminarContacto(id);
        await cargarContactos();
      } else {
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

  void buscarContactos(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(busqueda: '', contactosFiltrados: null, error: null));
      return;
    }

    final queryLower = query.toLowerCase();
    final contactosFiltrados =
        state.contactos.where((contacto) {
          return contacto.nombreCompleto.toLowerCase().contains(queryLower) ||
              contacto.telefono.toLowerCase().contains(queryLower) ||
              contacto.email.toLowerCase().contains(queryLower);
        }).toList();

    emit(
      state.copyWith(
        busqueda: query,
        contactosFiltrados: contactosFiltrados,
        error:
            contactosFiltrados.isEmpty ? 'No se encontraron contactos' : null,
      ),
    );
  }

  Future<void> toggleFavorito(Contacto contacto) async {
    emit(state.copyWith(cargando: true));
    try {
      if (state.esFavorito(contacto.id)) {
        await favoritoRepository.eliminarFavorito(contacto.id);
      } else {
        await favoritoRepository.agregarFavorito(contacto.id);
      }
      final favoritos = favoritoRepository.obtenerFavoritos();
      emit(state.copyWith(favoritos: favoritos, cargando: false, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  Future<void> limpiarFavoritos() async {
    emit(state.copyWith(cargando: true));
    try {
      await favoritoRepository.limpiarFavoritos();
      final favoritos = favoritoRepository.obtenerFavoritos();
      emit(state.copyWith(favoritos: favoritos, cargando: false, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), cargando: false));
    }
  }

  void cambiarTema(bool temaOscuro) {
    emit(state.copyWith(temaOscuro: temaOscuro));
  }
}
