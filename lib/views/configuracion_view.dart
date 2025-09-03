import 'package:flutter/material.dart';
import '../widgets/theme_switch.dart';

// Clase que representa la vista de configuración
class ConfiguracionView extends StatelessWidget {
  const ConfiguracionView({super.key});

  // Contiene el AppBar y el cuerpo con opciones de configuración
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.blue[800],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferencias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Tema oscuro'), const ThemeSwitch()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
