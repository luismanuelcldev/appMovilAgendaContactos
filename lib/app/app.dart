// Importamos los paquetes necesarios para la aplicación
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_final_agenda_contactos/cubit/agenda_cubit.dart';
import 'router.dart';

/// Widget principal que configura la aplicación
class AppAgenda extends StatelessWidget {
  // Constructor constante con key opcional
  const AppAgenda({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilizamos BlocBuilder para reconstruir la UI cuando cambia el estado
    return BlocBuilder<AgendaCubit, AgendaState>(
      builder: (context, state) {
        // Configuramos MaterialApp con soporte para enrutamiento
        return MaterialApp.router(
          title: 'Agenda de Contactos',
          debugShowCheckedModeBanner: false, // Removemos el banner de debug
          // Configuración del tema claro
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[800]!,
              secondary: Colors.blue[800]!,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[800],
              elevation: 4,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
          ),

          // Configuracion del tema oscuro
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blue[200]!,
              secondary: Colors.blue[200]!,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[800],
              elevation: 4,
              iconTheme: const IconThemeData(color: Colors.white),
            ),

            // Configuracion específica para las tarjetas en modo oscuro
            cardTheme: CardTheme(
              color: Colors.grey[800],
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
          ),

          // Seleccion del tema basado en el estado
          themeMode: state.temaOscuro ? ThemeMode.dark : ThemeMode.light,

          // Configuracion del enrutador
          routerConfig: router,
        );
      },
    );
  }
}
