// Importo los paquetes necesarias
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'cubit/agenda_cubit.dart';
import 'repositories/contacto_repository.dart';
import 'repositories/favorito_repository.dart';
import 'services/api_service.dart';

// Función principal que inicializa la aplicación
void main() async {
  // Aseguro que los bindings de Flutter estén inicializados antes de ejecutar código asíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializo SharedPreferences para persistencia local
  final prefs = await SharedPreferences.getInstance();

  // Instancio el servicio de API y los repositorios necesarios
  final apiService = ApiService();
  final contactoRepository = ContactoRepository(apiService, prefs);
  final favoritoRepository = FavoritoRepository(prefs);

  // Ejecuto la aplicación inyectando el Cubit globalmente
  runApp(
    BlocProvider(
      create:
          (context) => AgendaCubit(
            contactoRepository: contactoRepository,
            favoritoRepository: favoritoRepository,
          )..cargarContactos(), // Cargo los contactos al iniciar
      child: const AppAgenda(),
    ),
  );
}
