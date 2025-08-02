import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../models/contacto.dart';

class ContactoItem extends StatelessWidget {
  final Contacto contacto;
  final bool esFavorito;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorito;

  const ContactoItem({
    super.key,
    required this.contacto,
    required this.esFavorito,
    required this.onTap,
    required this.onToggleFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildContactImage(),
      title: Text(contacto.nombreCompleto),
      subtitle: Text(contacto.telefono),
      trailing: IconButton(
        icon: Icon(
          esFavorito ? Icons.favorite : Icons.favorite_border,
          color: esFavorito ? Colors.red : null,
        ),
        onPressed: onToggleFavorito,
      ),
      onTap: onTap,
    );
  }

  Widget _buildContactImage() {
    ImageProvider? imageProvider;

    if (contacto.imagenUrl.startsWith('http')) {
      imageProvider = NetworkImage(contacto.imagenUrl);
    } else if (contacto.imagenUrl.isNotEmpty) {
      if (kIsWeb) {
        imageProvider = NetworkImage(contacto.imagenUrl);
      } else {
        imageProvider = FileImage(File(contacto.imagenUrl));
      }
    }

    if (imageProvider != null) {
      return CircleAvatar(
        backgroundImage: imageProvider,
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.blue[100],
      child: Icon(Icons.person, color: Colors.blue[800]),
    );
  }
}
