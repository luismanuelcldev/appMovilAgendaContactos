// Importamos los paquetes necesarios para la aplicación
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_final_agenda_contactos/cubit/agenda_cubit.dart';
import 'router.dart';

// Widget principal que configura la aplicación
class AppAgenda extends StatelessWidget {
  const AppAgenda({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucho el estado del Cubit para cambiar el tema dinámicamente
    return BlocBuilder<AgendaCubit, AgendaState>(
      builder: (context, state) {
        // Configuro MaterialApp con soporte para enrutamiento
        return MaterialApp.router(
          title: 'Agenda de Contactos',
          debugShowCheckedModeBanner: false, // Oculto el banner de debug
          // Configuro el tema claro
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

          // Configuro el tema oscuro
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
            // Configuración específica para las tarjetas en modo oscuro
            cardTheme: CardThemeData(
              color: Colors.grey[800],
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
          ),

          // Selecciono el tema basado en el estado del Cubit
          themeMode: state.temaOscuro ? ThemeMode.dark : ThemeMode.light,

          // Asigno la configuración del enrutador
          routerConfig: router,
        );
      },
    );
  }
}
