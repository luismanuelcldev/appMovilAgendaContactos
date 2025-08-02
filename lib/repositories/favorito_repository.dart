import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorito.dart';

class FavoritoRepository {
  final SharedPreferences _prefs;
  static const String _key = 'favoritos';

  FavoritoRepository(this._prefs);

  List<Favorito> obtenerFavoritos() {
    final favoritosJson = _prefs.getStringList(_key) ?? [];
    return favoritosJson
        .map((json) => Favorito.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> agregarFavorito(String contactoId) async {
    final favoritos = obtenerFavoritos();
    if (!favoritos.any((f) => f.contactoId == contactoId)) {
      favoritos.add(
        Favorito(contactoId: contactoId, agregadoEn: DateTime.now()),
      );
      await _guardarFavoritos(favoritos);
    }
  }

  Future<void> eliminarFavorito(String contactoId) async {
    final favoritos = obtenerFavoritos();
    favoritos.removeWhere((f) => f.contactoId == contactoId);
    await _guardarFavoritos(favoritos);
  }

  Future<void> limpiarFavoritos() async {
    await _prefs.remove(_key);
  }

  Future<void> _guardarFavoritos(List<Favorito> favoritos) async {
    final favoritosJson =
        favoritos.map((favorito) => jsonEncode(favorito.toJson())).toList();
    await _prefs.setStringList(_key, favoritosJson);
  }
}
