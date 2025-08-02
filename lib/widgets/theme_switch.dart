import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/agenda_cubit.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaCubit, AgendaState>(
      builder: (context, state) {
        return Switch(
          value: state.temaOscuro,
          onChanged: (value) => context.read<AgendaCubit>().cambiarTema(value),
        );
      },
    );
  }
}
