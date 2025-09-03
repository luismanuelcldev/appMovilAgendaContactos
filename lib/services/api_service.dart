// Importar paquetes necesarios
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // URL de la API
      baseUrl: 'https://randomuser.me/api/',
      connectTimeout: const Duration(
        seconds: 5,
      ), // Tiempo de espera para conexión
      receiveTimeout: const Duration(
        seconds: 5,
      ), // Tiempo de espera para recibir la respuesta
    ),
  );

  Future<List<Map<String, dynamic>>> obtenerContactos({
    int cantidad = 20, // Cantidad de contactos a obtener
  }) async {
    try {
      final response = await _dio.get(
        '',
        // Parámetro para resultados
        queryParameters: {
          'results': cantidad,
          // Campos a incluir
          'inc': 'name,email,phone,picture,login,dob,location',
          'nat': 'es',
          'seed': 'espanol',
        },
      );

      // Convertir resultados a lista
      final results = List<Map<String, dynamic>>.from(response.data['results']);

      // Asignar valor si no hay teléfono
      for (var contacto in results) {
        if (contacto['phone'] == null) {
          contacto['phone'] = 'No disponible';
        }
      }

      // Retornar lista de contactos
      return results;
    } catch (e) {
      throw Exception('Error al obtener contactos: ${e.toString()}');
    }
  }
}
