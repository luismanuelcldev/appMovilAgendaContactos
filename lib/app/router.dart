// router.dart
import 'package:go_router/go_router.dart';
import '../models/contacto.dart';
import '../views/configuracion_view.dart';
import '../views/contactos_view.dart';
import '../views/detalle_contacto_view.dart';
import '../views/editar_contacto_view.dart';
import '../views/favoritos_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ContactosView(),
      routes: [
        GoRoute(
          path: 'detalle/:id',
          builder: (context, state) {
            final contacto = state.extra as Contacto;
            return DetalleContactoView(contacto: contacto);
          },
        ),
        GoRoute(
          path: 'favoritos',
          builder: (context, state) => const FavoritosView(),
        ),
        GoRoute(
          path: 'configuracion',
          builder: (context, state) => const ConfiguracionView(),
        ),
        GoRoute(
          path: 'nuevo',
          builder: (context, state) => const EditarContactoView(),
        ),
        GoRoute(
          path: 'editar/:id',
          builder: (context, state) {
            final contacto = state.extra as Contacto;
            return EditarContactoView(contacto: contacto);
          },
        ),
      ],
    ),
  ],
);
