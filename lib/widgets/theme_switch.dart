// Importo las paquetes necesarios
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/agenda_cubit.dart';

// Widget que permite alternar entre tema claro y oscuro
class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucho el estado del Cubit para reflejar el tema actual
    return BlocBuilder<AgendaCubit, AgendaState>(
      builder: (context, state) {
        // Switch que cambia el tema al ser activado/desactivado
        return Switch(
          value: state.temaOscuro,
          onChanged: (value) => context.read<AgendaCubit>().cambiarTema(value),
        );
      },
    );
  }
}
