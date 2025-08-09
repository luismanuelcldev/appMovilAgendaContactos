// Archivo de configuración de rutas y modelos de la aplicación
import 'package:go_router/go_router.dart';
import '../models/contacto.dart';

// Importación de todas las vistas de la aplicación
import '../views/configuracion_view.dart';
import '../views/contactos_view.dart';
import '../views/detalle_contacto_view.dart';
import '../views/editar_contacto_view.dart';
import '../views/favoritos_view.dart';

/// Configuración principal del enrutador de la aplicación
final router = GoRouter(
  routes: [
    // Ruta raiz - Pantalla principal de contactos
    GoRoute(
      path: '/',
      builder: (context, state) => const ContactosView(),
      routes: [
        // Ruta para ver detalles de un contacto
        GoRoute(
          path: 'detalle/:id',
          builder: (context, state) {
            // Extraemos el contacto pasado como parametro extra
            final contacto = state.extra as Contacto;
            return DetalleContactoView(contacto: contacto);
          },
        ),

        // Ruta para ver contactos favoritos
        GoRoute(
          path: 'favoritos',
          builder: (context, state) => const FavoritosView(),
        ),

        // Ruta para la pantalla de configuracion
        GoRoute(
          path: 'configuracion',
          builder: (context, state) => const ConfiguracionView(),
        ),

        // Ruta para crear un nuevo contacto
        GoRoute(
          path: 'nuevo',
          builder: (context, state) => const EditarContactoView(),
        ),

        // Ruta para editar un contacto existente
        GoRoute(
          path: 'editar/:id',
          builder: (context, state) {
            // Extraemos el contacto a editar de los parámetros extra
            final contacto = state.extra as Contacto;
            return EditarContactoView(contacto: contacto);
          },
        ),
      ],
    ),
  ],
);
