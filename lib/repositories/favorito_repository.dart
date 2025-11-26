// Importaciones necesarias para la gestión de favoritos
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorito.dart';

// Repositorio encargado de gestionar los contactos favoritos
class FavoritoRepository {
  final SharedPreferences _prefs;
  static const String _key = 'favoritos';

  // Constructor que inicializa SharedPreferences
  FavoritoRepository(this._prefs);

  // Obtiene la lista de favoritos almacenados
  List<Favorito> obtenerFavoritos() {
    final favoritosJson = _prefs.getStringList(_key) ?? [];
    // Deserializo cada string JSON a un objeto Favorito
    return favoritosJson
        .map((json) => Favorito.fromJson(jsonDecode(json)))
        .toList();
  }

  // Agrega un nuevo favorito si no existe ya en la lista
  Future<void> agregarFavorito(String contactoId) async {
    final favoritos = obtenerFavoritos();
    // Verifico si el contacto ya está en favoritos para evitar duplicados
    if (!favoritos.any((f) => f.contactoId == contactoId)) {
      favoritos.add(
        Favorito(contactoId: contactoId, agregadoEn: DateTime.now()),
      );
      // Persisto la lista actualizada
      await _guardarFavoritos(favoritos);
    }
  }

  // Elimina un favorito de la lista por su ID de contacto
  Future<void> eliminarFavorito(String contactoId) async {
    final favoritos = obtenerFavoritos();
    // Filtro la lista removiendo el favorito correspondiente
    favoritos.removeWhere((f) => f.contactoId == contactoId);
    await _guardarFavoritos(favoritos);
  }

  // Limpia todos los favoritos almacenados
  Future<void> limpiarFavoritos() async {
    await _prefs.remove(_key);
  }

  // Guarda la lista de favoritos en formato JSON en SharedPreferences
  Future<void> _guardarFavoritos(List<Favorito> favoritos) async {
    // Serializo la lista de objetos Favorito a una lista de strings JSON
    final favoritosJson =
        favoritos.map((favorito) => jsonEncode(favorito.toJson())).toList();
    await _prefs.setStringList(_key, favoritosJson);
  }
}
