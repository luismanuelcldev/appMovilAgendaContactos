import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://randomuser.me/api/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<List<Map<String, dynamic>>> obtenerContactos({
    int cantidad = 20,
  }) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'results': cantidad,
          'inc': 'name,email,phone,picture,login,dob,location',
          'nat': 'es',
          'seed': 'espanol', // Para consistencia en los datos
        },
      );

      final results = List<Map<String, dynamic>>.from(response.data['results']);

      for (var contacto in results) {
        if (contacto['phone'] == null) {
          contacto['phone'] = 'No disponible';
        }
      }

      return results;
    } catch (e) {
      throw Exception('Error al obtener contactos: ${e.toString()}');
    }
  }
}
