// Importo los paquetes necesarias
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'cubit/agenda_cubit.dart';
import 'repositories/contacto_repository.dart';
import 'repositories/favorito_repository.dart';
import 'services/api_service.dart';

// Inicializo los servicios y repositorios
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final apiService = ApiService();
  final contactoRepository = ContactoRepository(apiService, prefs);
  final favoritoRepository = FavoritoRepository(prefs);

  // Configuro el BlocProvider para la AgendaCubit
  runApp(
    BlocProvider(
      create:
          (context) => AgendaCubit(
            contactoRepository: contactoRepository,
            favoritoRepository: favoritoRepository,
          )..cargarContactos(),
      child: const AppAgenda(),
    ),
  );
}
