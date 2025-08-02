import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contacto.dart';
import '../services/api_service.dart';

class ContactoRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs;
  static const String _key = 'contactos_locales';

  ContactoRepository(this._apiService, this._prefs);

  Future<List<Contacto>> obtenerContactos() async {
    try {
      final contactosLocales = await _obtenerContactosLocales();

      final datosApi = await _apiService.obtenerContactos();
      final contactosApi =
          datosApi.map((json) {
            final contacto = Contacto.fromJson(json);
            return contacto.copyWith(id: 'api_${contacto.id}');
          }).toList();

      return [...contactosLocales, ...contactosApi];
    } catch (e) {
      return _obtenerContactosLocales();
    }
  }

  Future<List<Contacto>> _obtenerContactosLocales() async {
    final contactosJson = _prefs.getStringList(_key) ?? [];
    return contactosJson
        .map((json) => Contacto.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> agregarContacto(Contacto contacto) async {
    final contactos = await _obtenerContactosLocales();
    contactos.add(contacto);
    await _guardarContactos(contactos);
  }

  Future<void> actualizarContacto(Contacto contacto) async {
    final contactos = await _obtenerContactosLocales();
    final index = contactos.indexWhere((c) => c.id == contacto.id);
    if (index != -1) {
      contactos[index] = contacto;
      await _guardarContactos(contactos);
    }
  }

  Future<void> eliminarContacto(String id) async {
    final contactos = await _obtenerContactosLocales();
    contactos.removeWhere((c) => c.id == id);
    await _guardarContactos(contactos);
  }

  Future<void> _guardarContactos(List<Contacto> contactos) async {
    final contactosJson =
        contactos.map((contacto) => jsonEncode(contacto.toJson())).toList();
    await _prefs.setStringList(_key, contactosJson);
  }
}
