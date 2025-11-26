import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import '../models/contacto.dart';

// Widget que representa un elemento individual en la lista de contactos
class ContactoItem extends StatelessWidget {
  final Contacto contacto;
  final bool esFavorito;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorito;

  // Constructor que recibe los datos del contacto y callbacks de interacción
  const ContactoItem({
    super.key,
    required this.contacto,
    required this.esFavorito,
    required this.onTap,
    required this.onToggleFavorito,
  });

  @override
  Widget build(BuildContext context) {
    // Construyo un ListTile con la información del contacto
    return ListTile(
      leading: _buildContactImage(), // Imagen de perfil
      title: Text(contacto.nombreCompleto), // Nombre completo
      subtitle: Text(contacto.telefono), // Número de teléfono
      trailing: IconButton(
        // Icono de favorito interactivo
        icon: Icon(
          esFavorito ? Icons.favorite : Icons.favorite_border,
          color: esFavorito ? Colors.red : null,
        ),
        onPressed: onToggleFavorito,
      ),
      onTap: onTap, // Acción al tocar el elemento
    );
  }

  // Método auxiliar para construir la imagen del contacto
  Widget _buildContactImage() {
    ImageProvider? imageProvider;

    // Determino el proveedor de imagen según el tipo de URL
    if (contacto.imagenUrl.startsWith('http')) {
      String imageUrl = contacto.imagenUrl;
      if (kIsWeb) {
        // Usamos corsproxy.io que suele ser más rápido y fiable para imágenes
        imageUrl =
            'https://corsproxy.io/?${Uri.encodeComponent(contacto.imagenUrl)}';
      }
      imageProvider = NetworkImage(imageUrl);
    } else if (contacto.imagenUrl.startsWith('data:')) {
      // Manejo imágenes en Base64
      try {
        imageProvider = MemoryImage(
          base64Decode(contacto.imagenUrl.split(',').last),
        );
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
      }
    } else if (contacto.imagenUrl.isNotEmpty) {
      // Manejo imágenes locales (archivos)
      if (kIsWeb) {
        imageProvider = NetworkImage(contacto.imagenUrl);
      } else {
        imageProvider = FileImage(File(contacto.imagenUrl));
      }
    }

    // Si se pudo crear un proveedor de imagen, retorno la imagen recortada
    if (imageProvider != null) {
      return ClipOval(
        child: Image(
          image: imageProvider,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // En caso de error al cargar, muestro el avatar por defecto
            debugPrint('Error loading image: $error');
            return _buildDefaultAvatar();
          },
          loadingBuilder: (context, child, loadingProgress) {
            // Muestro un indicador de carga mientras se descarga la imagen
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              ),
            );
          },
        ),
      );
    } else {
      // Si no hay imagen, muestro el avatar por defecto
      return _buildDefaultAvatar();
    }
  }

  // Construye un avatar por defecto con las iniciales o un icono
  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.blue[100],
      child: Icon(Icons.person, color: Colors.blue[800]),
    );
  }
}
