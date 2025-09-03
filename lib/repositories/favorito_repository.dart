import 'dart:convert'; // Importa la biblioteca para trabajar con JSON.
import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca para manejar preferencias compartidas.
import '../models/favorito.dart'; // Importa el modelo de Favorito.

class FavoritoRepository {
  final SharedPreferences
  _prefs; // Instancia de SharedPreferences para el almacenamiento de datos.
  static const String _key = 'favoritos';

  FavoritoRepository(
    this._prefs,
  ); // Constructor que inicializa SharedPreferences.

  // Obtiene la lista de favoritos almacenados.
  List<Favorito> obtenerFavoritos() {
    final favoritosJson = _prefs.getStringList(_key) ?? [];
    return favoritosJson
        .map((json) => Favorito.fromJson(jsonDecode(json)))
        .toList();
  }

  // Agregar un nuevo favorito si no existe ya en la lista.
  Future<void> agregarFavorito(String contactoId) async {
    final favoritos = obtenerFavoritos();
    if (!favoritos.any((f) => f.contactoId == contactoId)) {
      favoritos.add(
        Favorito(contactoId: contactoId, agregadoEn: DateTime.now()),
      );
      await _guardarFavoritos(favoritos);
    }
  }

  // Elimina un favorito de la lista.
  Future<void> eliminarFavorito(String contactoId) async {
    final favoritos = obtenerFavoritos();
    favoritos.removeWhere((f) => f.contactoId == contactoId);
    await _guardarFavoritos(favoritos);
  }

  // Limpia todos los favoritos almacenados.
  Future<void> limpiarFavoritos() async {
    await _prefs.remove(_key);
  }

  // Guarda la lista de favoritos en formato JSON.
  Future<void> _guardarFavoritos(List<Favorito> favoritos) async {
    final favoritosJson =
        favoritos
            .map((favorito) => jsonEncode(favorito.toJson()))
            .toList(); // Convierte cada Favorito a JSON.
    await _prefs.setStringList(_key, favoritosJson);
  }
}
