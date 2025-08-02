import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/agenda_cubit.dart';
import '../widgets/contacto_item.dart';

class ContactosView extends StatelessWidget {
  const ContactosView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Contactos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => context.go('/nuevo'),
            tooltip: 'Agregar contacto',
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () => context.go('/favoritos'),
            tooltip: 'Favoritos',
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.go('/configuracion'),
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: BlocConsumer<AgendaCubit, AgendaState>(
        listener: (context, state) {
          if (searchController.text != state.busqueda) {
            searchController.text = state.busqueda;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar contactos...',
                    prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    suffixIcon:
                        state.busqueda.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.close, color: Colors.blue[800]),
                              onPressed: () {
                                searchController.clear();
                                context.read<AgendaCubit>().buscarContactos('');
                              },
                            )
                            : null,
                  ),
                  onChanged: (query) {
                    context.read<AgendaCubit>().buscarContactos(query);
                  },
                ),
              ),
              Expanded(child: _buildContactList(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContactList(BuildContext context, AgendaState state) {
    if (state.cargando) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            state.error!,
            style: TextStyle(color: Colors.red[700], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.contactosMostrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 60,

              color: Colors.blue[800]!.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              state.busqueda.isNotEmpty
                  ? 'No se encontraron contactos para "${state.busqueda}"'
                  : 'No hay contactos',
              style: TextStyle(color: Colors.blue[800], fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: state.contactosMostrados.length,
      itemBuilder: (ctx, index) {
        final contacto = state.contactosMostrados[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ContactoItem(
            contacto: contacto,
            esFavorito: state.esFavorito(contacto.id),
            onTap: () => context.go('/detalle/${contacto.id}', extra: contacto),
            onToggleFavorito:
                () => context.read<AgendaCubit>().toggleFavorito(contacto),
          ),
        );
      },
    );
  }
}
