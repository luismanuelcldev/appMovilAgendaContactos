// Importaciones necesarias para la gestión de contactos
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contacto.dart';
import '../services/api_service.dart';

// Repositorio encargado de gestionar los contactos (locales y remotos)
class ContactoRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs;
  static const String _key = 'contactos_locales';

  // Constructor que inyecta las dependencias necesarias
  ContactoRepository(this._apiService, this._prefs);

  // Obtiene la lista combinada de contactos locales y de la API
  Future<List<Contacto>> obtenerContactos() async {
    try {
      // Recupero primero los contactos almacenados localmente
      final contactosLocales = await _obtenerContactosLocales();

      // Intento obtener los contactos de la API externa
      final datosApi = await _apiService.obtenerContactos();

      // Mapeo los datos de la API a objetos Contacto y prefijo sus IDs
      final contactosApi =
          datosApi.map((json) {
            final contacto = Contacto.fromJson(json);
            // Prefijo el ID para distinguir contactos de API de los locales
            return contacto.copyWith(id: 'api_${contacto.id}');
          }).toList();

      // Retorno la unión de ambas listas
      return [...contactosLocales, ...contactosApi];
    } catch (e) {
      // Si falla la API, retorno solo los contactos locales para mantener funcionalidad offline
      return _obtenerContactosLocales();
    }
  }

  // Recupera los contactos guardados en SharedPreferences
  Future<List<Contacto>> _obtenerContactosLocales() async {
    final contactosJson = _prefs.getStringList(_key) ?? [];
    // Deserializo cada string JSON a un objeto Contacto
    return contactosJson
        .map((json) => Contacto.fromJson(jsonDecode(json)))
        .toList();
  }

  // Agrega un nuevo contacto al almacenamiento local
  Future<void> agregarContacto(Contacto contacto) async {
    final contactos = await _obtenerContactosLocales();
    contactos.add(contacto);
    // Persisto la lista actualizada
    await _guardarContactos(contactos);
  }

  // Actualiza un contacto existente en el almacenamiento local
  Future<void> actualizarContacto(Contacto contacto) async {
    final contactos = await _obtenerContactosLocales();
    final index = contactos.indexWhere((c) => c.id == contacto.id);

    if (index != -1) {
      // Reemplazo el contacto antiguo con el actualizado
      contactos[index] = contacto;
      await _guardarContactos(contactos);
    }
  }

  // Elimina un contacto del almacenamiento local por su ID
  Future<void> eliminarContacto(String id) async {
    final contactos = await _obtenerContactosLocales();
    // Filtro la lista removiendo el contacto con el ID especificado
    contactos.removeWhere((c) => c.id == id);
    await _guardarContactos(contactos);
  }

  // Guarda la lista de contactos en SharedPreferences
  Future<void> _guardarContactos(List<Contacto> contactos) async {
    // Serializo la lista de objetos Contacto a una lista de strings JSON
    final contactosJson =
        contactos.map((contacto) => jsonEncode(contacto.toJson())).toList();
    await _prefs.setStringList(_key, contactosJson);
  }
}
