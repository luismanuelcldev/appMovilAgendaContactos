// Archivo de configuración de rutas y modelos de la aplicación
import 'package:go_router/go_router.dart';
import '../models/contacto.dart';
import '../views/configuracion_view.dart';
import '../views/contactos_view.dart';
import '../views/detalle_contacto_view.dart';
import '../views/editar_contacto_view.dart';
import '../views/favoritos_view.dart';

// Configuración principal del enrutador de la aplicación usando GoRouter
final router = GoRouter(
  routes: [
    // Ruta raíz que muestra la lista de contactos
    GoRoute(
      path: '/',
      builder: (context, state) => const ContactosView(),
      routes: [
        // Ruta para ver los detalles de un contacto específico
        GoRoute(
          path: 'detalle/:id',
          builder: (context, state) {
            // Extraigo el objeto Contacto de los argumentos extra
            final contacto = state.extra as Contacto;
            return DetalleContactoView(contacto: contacto);
          },
        ),

        // Ruta para ver la lista de favoritos
        GoRoute(
          path: 'favoritos',
          builder: (context, state) => const FavoritosView(),
        ),

        // Ruta para la pantalla de configuración
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
            // Extraigo el contacto a editar de los argumentos extra
            final contacto = state.extra as Contacto;
            return EditarContactoView(contacto: contacto);
          },
        ),
      ],
    ),
  ],
);
