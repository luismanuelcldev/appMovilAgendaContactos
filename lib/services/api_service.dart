// Importar paquetes necesarios
import 'package:dio/dio.dart';

// Servicio encargado de la comunicación con la API externa
class ApiService {
  // Configuro el cliente HTTP Dio con la URL base y timeouts
  final Dio _dio = Dio(
    BaseOptions(
      // URL de la API de Random User Generator
      baseUrl: 'https://randomuser.me/api/',
      connectTimeout: const Duration(
        seconds: 5,
      ), // Tiempo de espera para conexión
      receiveTimeout: const Duration(
        seconds: 5,
      ), // Tiempo de espera para recibir la respuesta
    ),
  );

  // Obtiene una lista de contactos aleatorios desde la API
  Future<List<Map<String, dynamic>>> obtenerContactos({
    int cantidad = 50, // Cantidad de contactos a obtener por defecto
  }) async {
    try {
      // Realizo la petición GET a la API
      final response = await _dio.get(
        '',
        // Parámetros de consulta para personalizar la respuesta
        queryParameters: {
          'results': cantidad,
          // Campos específicos a incluir en la respuesta para optimizar
          'inc': 'name,email,phone,picture,login,dob,location',
          'nat': 'es', // Filtro por nacionalidad española
          'seed':
              'espanol', // Semilla para obtener siempre los mismos resultados (opcional)
        },
      );

      // Convierto los resultados a una lista tipada
      final results = List<Map<String, dynamic>>.from(response.data['results']);

      // Proceso cada contacto para normalizar datos
      for (var contacto in results) {
        // Asigno un valor por defecto si no hay teléfono
        if (contacto['phone'] == null) {
          contacto['phone'] = 'No disponible';
        }
        // Aseguro que las URLs de las imágenes usen HTTPS
        if (contacto['picture'] != null) {
          if (contacto['picture']['large'] != null) {
            contacto['picture']['large'] = contacto['picture']['large']
                .toString()
                .replaceAll('http://', 'https://');
          }
          if (contacto['picture']['medium'] != null) {
            contacto['picture']['medium'] = contacto['picture']['medium']
                .toString()
                .replaceAll('http://', 'https://');
          }
          if (contacto['picture']['thumbnail'] != null) {
            contacto['picture']['thumbnail'] = contacto['picture']['thumbnail']
                .toString()
                .replaceAll('http://', 'https://');
          }
        }
      }

      // Retorno la lista de contactos procesada
      return results;
    } catch (e) {
      // Lanzo una excepción personalizada en caso de error
      throw Exception('Error al obtener contactos: ${e.toString()}');
    }
  }
}
