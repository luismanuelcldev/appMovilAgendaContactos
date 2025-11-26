import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/agenda_cubit.dart';
import '../widgets/contacto_item.dart';

class FavoritosView extends StatelessWidget {
  const FavoritosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Contactos Favoritos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        'Limpiar favoritos',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                      content: const Text(
                        '¿Estás seguro de eliminar todos tus contactos favoritos?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AgendaCubit>().limpiarFavoritos();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Limpiar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.grey[50]!],
          ),
        ),
        child: BlocBuilder<AgendaCubit, AgendaState>(
          builder: (context, state) {
            if (state.contactosFavoritos.isEmpty) {
              return Center(
                child: Text(
                  'No tienes contactos favoritos',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.contactosFavoritos.length,
              itemBuilder: (ctx, index) {
                final contacto = state.contactosFavoritos[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ContactoItem(
                    contacto: contacto,
                    esFavorito: true,
                    onTap:
                        () => context.go(
                          '/detalle/${contacto.id}',
                          extra: contacto,
                        ),
                    onToggleFavorito:
                        () => context.read<AgendaCubit>().toggleFavorito(
                          contacto,
                        ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
