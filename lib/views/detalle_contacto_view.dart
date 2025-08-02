import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/agenda_cubit.dart';
import '../models/contacto.dart';

class DetalleContactoView extends StatelessWidget {
  final Contacto contacto;

  const DetalleContactoView({super.key, required this.contacto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          contacto.nombreCompleto,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (context.read<AgendaCubit>().esContactoLocal(contacto.id))
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed:
                  () => context.go('/editar/${contacto.id}', extra: contacto),
              tooltip: 'Editar contacto',
            ),
        ],
      ),
      body: BlocBuilder<AgendaCubit, AgendaState>(
        builder: (context, state) {
          final esFavorito = state.esFavorito(contacto.id);
          final esContactoLocal = context.read<AgendaCubit>().esContactoLocal(
            contacto.id,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.network(
                      contacto.imagenUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue[800]!,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.blue[800],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  contacto.nombreCompleto,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 30),
                _buildInfoCard(Icons.email, contacto.email),
                _buildInfoCard(Icons.phone, contacto.telefono),
                _buildInfoCard(
                  Icons.cake,
                  '${contacto.fechaNacimiento.day} de ${_getMesEnEspanol(contacto.fechaNacimiento.month)} de ${contacto.fechaNacimiento.year}',
                ),
                _buildInfoCard(Icons.location_on, contacto.direccion),
                const SizedBox(height: 30),
                if (esContactoLocal) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed:
                            () => context.go(
                              '/editar/${contacto.id}',
                              extra: contacto,
                            ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Editar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    'Eliminar contacto',
                                    style: TextStyle(color: Colors.blue[800]),
                                  ),
                                  content: const Text(
                                    '¿Estás seguro de eliminar este contacto?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancelar',
                                        style: TextStyle(
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<AgendaCubit>()
                                            .eliminarContacto(contacto.id);
                                        Navigator.pop(context);
                                        context.pop();
                                      },
                                      child: const Text(
                                        'Eliminar',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          'Eliminar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          esFavorito ? Colors.red[400] : Colors.blue[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed:
                        () => context.read<AgendaCubit>().toggleFavorito(
                          contacto,
                        ),
                    icon: Icon(
                      esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    label: Text(
                      esFavorito
                          ? 'Quitar de favoritos'
                          : 'Agregar a favoritos',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blue[800]),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text.isNotEmpty ? text : 'No disponible',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  String _getMesEnEspanol(int mes) {
    switch (mes) {
      case 1:
        return 'enero';
      case 2:
        return 'febrero';
      case 3:
        return 'marzo';
      case 4:
        return 'abril';
      case 5:
        return 'mayo';
      case 6:
        return 'junio';
      case 7:
        return 'julio';
      case 8:
        return 'agosto';
      case 9:
        return 'septiembre';
      case 10:
        return 'octubre';
      case 11:
        return 'noviembre';
      case 12:
        return 'diciembre';
      default:
        return '';
    }
  }
}
