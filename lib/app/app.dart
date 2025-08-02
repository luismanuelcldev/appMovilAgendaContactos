import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_final_agenda_contactos/cubit/agenda_cubit.dart';
import 'router.dart';

class AppAgenda extends StatelessWidget {
  const AppAgenda({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaCubit, AgendaState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Agenda de Contactos',
          debugShowCheckedModeBanner: false,
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
            cardTheme: CardTheme(
              color: Colors.grey[800],
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
            ),
          ),
          themeMode: state.temaOscuro ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
        );
      },
    );
  }
}
