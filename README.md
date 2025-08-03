# 📱 App Agenda de Contactos Flutter 📞


## Objetivo del Proyecto:
Desarrollar una aplicación móvil multiplataforma utilizando Flutter para la gestión eficiente de contactos personales. La aplicación permite a los usuarios crear, editar, eliminar y organizar contactos con funcionalidades avanzadas como sistema de favoritos, búsqueda inteligente, selección de imágenes y sincronización con APIs externas.

> [!NOTE]
> Proyecto final desarrollado con Flutter 3.29.3 y arquitectura BLoC para gestión de estado

## Funcionalidades Principales:

- **Gestión Completa de Contactos:** Crear, editar, eliminar y visualizar contactos con información detallada (nombre, apellido, email, teléfono, dirección, fecha de nacimiento).

- **Sistema de Favoritos:** Marcar contactos importantes como favoritos para acceso rápido con vista especializada.

- **Búsqueda Inteligente:** Filtrado en tiempo real por nombre, apellido, teléfono o email con resultados instantáneos.

- **Gestión de Imágenes:** Selección de fotos de perfil desde galería o cámara con compatibilidad multiplataforma.

- **Integración API Externa:** Sincronización con RandomUser.me para obtener contactos de ejemplo en español.

- **Persistencia Local:** Almacenamiento offline de contactos y favoritos usando SharedPreferences.

- **Interfaz Adaptativa:** Soporte para tema claro y oscuro con Material Design 3.

- **Multiplataforma:** Funcionamiento completo en web, Android, iOS, Windows, macOS y Linux.

- **Navegación Moderna:** Enrutamiento declarativo con GoRouter para experiencia fluida.

- **Validación de Formularios:** Campos obligatorios con validación en tiempo real.

## Desarrollador:

- [Luis Manuel - Desarrollador Full Stack](https://github.com/luismanuelcldev)

## Enlaces:

**Repositorio:** [GitHub Repository](https://github.com/luismanuelcldev/appMovilAgendaContactos)

## Capturas de Pantalla

>[!NOTE]
>Aquí se muestra un listado de todas las pantallas desarrolladas.

| Pantalla Principal de Contactos | Formulario Crear/Editar Contacto |
|-----------|-----------|
| ![Pantalla Principal]() | ![Formulario]() |

| Pantalla Detalle de Contacto | Pantalla Favoritos |
|-----------|-----------|
| ![Detalle]() | ![Favoritos]() |

| Pantalla Configuración |
|-----------|
| ![Configuración]() |

## Arquitectura Técnica

### Stack Tecnológico
- **Framework:** Flutter 3.29.3
- **Lenguaje:** Dart ^3.7.2
- **Arquitectura:** BLoC Pattern (flutter_bloc ^9.1.1)
- **Navegación:** GoRouter ^16.0.0
- **HTTP Client:** Dio ^5.8.0+1
- **Persistencia:** SharedPreferences ^2.5.3
- **Imágenes:** image_picker ^1.1.2
- **Archivos:** path_provider ^2.1.4

### Estructura del Proyecto
```
lib/
├── app/                 # Configuración de la aplicación
├── cubit/              # Gestión de estado (BLoC)
├── models/             # Modelos de datos
├── repositories/       # Capa de datos
├── services/           # Servicios externos
├── views/              # Interfaces de usuario
├── widgets/            # Componentes reutilizables
└── main.dart           # Punto de entrada
```

## Inicialización del Proyecto Flutter

Este archivo describe los pasos necesarios para inicializar el proyecto Flutter después de clonarlo o descargarlo.

### Requisitos Previos

- [Flutter](https://flutter.dev/docs/get-started/install) debe estar instalado en tu equipo (versión 3.29.3 o superior).
- Asegurate de tener todas las dependencias necesarias instaladas. Puedes ejecutar el siguiente comando:

  ```bash
  flutter doctor
  ```
  Asegurate de solucionar cualquier problema identificado por flutter doctor antes de continuar.

### Pasos de Inicialización

**Descargar el Proyecto:**
Clona el repositorio o descarga el proyecto desde GitHub.

```bash
git clone https://github.com/luismanuelcldev/appMovilAgendaContactos.git
cd proyecto_final_agenda_contactos
```

### Limpiar el Proyecto:
Ejecuta el siguiente comando para limpiar el proyecto.
```bash
flutter clean
```

### Obtener Dependencias:
Ejecuta el siguiente comando para obtener todas las dependencias del proyecto.
```bash
flutter pub get
```
Esto descargará todas las dependencias definidas en el archivo **pubspec.yaml.**

### Configuración Adicional (En caso de ser necesario):
Realiza cualquier configuración adicional necesaria según las instrucciones del proyecto.

## Ejecutar la Aplicación
Una vez completados los pasos anteriores, puedes ejecutar la aplicación Flutter con el siguiente comando que proporcionare:

```bash
# Para Web (recomendado)
flutter run -d chrome

# Para Android
flutter run -d android

# Para Windows
flutter run -d windows

# Para iOS (solo en macOS)
flutter run -d ios
```

Esto iniciará la aplicación en el emulador, dispositivo conectado o navegador web.

## Características Técnicas Implementadas

### Gestión de Estado
- **Patron BLoC:** Implementación robusta para manejo de estado reactivo
- **Estado Inmutable:** Uso de copyWith para actualizaciones seguras
- **Separación de Responsabilidades:** Cubit separado de la UI

### Persistencia de Datos
- **Almacenamiento Local:** SharedPreferences para contactos y favoritos
- **Serializacion JSON:** Modelos con toJson() y fromJson()
- **Gestión de Archivos:** Almacenamiento de imágenes en directorio de aplicación

### Funcionalidades Avanzadas
- **Busqueda en Tiempo Real:** Filtrado eficiente con debounce
- **Validacion de Formularios:** Campos requeridos con mensajes personalizados
- **Manejo de Errores:** Try-catch robusto con mensajes al usuario
- **Compatibilidad Web:** Adaptaciones específicas para navegadores

## Capturas de Funcionalidades

### Gestión de Contactos
- ✅ CRUD completo con validación
- ✅ Formularios dinámicos con DatePicker
- ✅ Selección de imágenes multiplataforma
- ✅ Confirmaciones de eliminación

### Sistema de Favoritos
- ✅ Toggle visual 
- ✅ Vista especializada para favoritos
- ✅ Gestión masiva de favoritos

### Integración API
- ✅ Contactos de ejemplo desde RandomUser.me
- ✅ Manejo de errores de conectividad

---