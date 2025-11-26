import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../cubit/agenda_cubit.dart';
import '../models/contacto.dart';

class EditarContactoView extends StatefulWidget {
  final Contacto? contacto;

  const EditarContactoView({super.key, this.contacto});

  @override
  State<EditarContactoView> createState() => _EditarContactoViewState();
}

class _EditarContactoViewState extends State<EditarContactoView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _direccionController;
  late DateTime _fechaNacimiento;
  String _imagenUrl = '';
  XFile? _imagenFile;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final contacto = widget.contacto;
    _nombreController = TextEditingController(text: contacto?.nombre ?? '');
    _apellidoController = TextEditingController(text: contacto?.apellido ?? '');
    _emailController = TextEditingController(text: contacto?.email ?? '');
    _telefonoController = TextEditingController(text: contacto?.telefono ?? '');
    _direccionController = TextEditingController(
      text: contacto?.direccion ?? '',
    );
    _fechaNacimiento = contacto?.fechaNacimiento ?? DateTime.now();
    _imagenUrl = contacto?.imagenUrl ?? '';

    // No inicializamos _imagenFile desde _imagenUrl porque XFile requiere un path real o bytes,
    // y si es una URL remota o base64, lo manejamos con _imagenUrl.
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<String> _guardarImagenLocalmente(XFile imagenFile) async {
    try {
      if (kIsWeb) {
        final bytes = await imagenFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        String mime = 'image/jpeg';
        if (imagenFile.name.toLowerCase().endsWith('.png')) {
          mime = 'image/png';
        }
        return 'data:$mime;base64,$base64Image';
      } else {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'contact_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await imagenFile.saveTo('${appDir.path}/$fileName');
        return '${appDir.path}/$fileName';
      }
    } catch (e) {
      debugPrint('Error al guardar imagen: $e');
      return imagenFile.path;
    }
  }

  Future<void> _mostrarOpcionesImagen() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _seleccionarImagen(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () {
                  Navigator.of(context).pop();
                  _seleccionarImagen(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('URL de imagen'),
                onTap: () {
                  Navigator.of(context).pop();
                  _ingresarUrlImagen();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _ingresarUrlImagen() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Ingresar URL de imagen'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'https://ejemplo.com/imagen.jpg',
                labelText: 'URL',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      _imagenUrl = controller.text;
                      _imagenFile = null;
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _imagenFile = pickedFile;

          if (kIsWeb) {
            _imagenUrl = pickedFile.path;
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Imagen seleccionada correctamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _seleccionarFecha() async {
    final fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fechaNacimiento = fechaSeleccionada;
      });
    }
  }

  Future<void> _guardarContacto() async {
    if (_formKey.currentState!.validate() && !_guardando) {
      setState(() => _guardando = true);

      try {
        final cubit = context.read<AgendaCubit>();
        String imagenUrlFinal = _imagenUrl;

        if (_imagenFile != null) {
          imagenUrlFinal = await _guardarImagenLocalmente(_imagenFile!);
        }

        if (widget.contacto == null) {
          final nuevoContacto = Contacto.nuevo(
            nombre: _nombreController.text,
            apellido: _apellidoController.text,
            email: _emailController.text,
            telefono: _telefonoController.text,
            imagenUrl: imagenUrlFinal,
            fechaNacimiento: _fechaNacimiento,
            direccion: _direccionController.text,
          );
          await cubit.agregarContacto(nuevoContacto);
        } else if (cubit.esContactoLocal(widget.contacto!.id)) {
          final contactoActualizado = widget.contacto!.copyWith(
            nombre: _nombreController.text,
            apellido: _apellidoController.text,
            email: _emailController.text,
            telefono: _telefonoController.text,
            imagenUrl: imagenUrlFinal,
            fechaNacimiento: _fechaNacimiento,
            direccion: _direccionController.text,
          );
          await cubit.actualizarContacto(contactoActualizado);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pueden editar contactos de la API'),
            ),
          );
          return;
        }

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.contacto == null ? 'Nuevo Contacto' : 'Editar Contacto',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _guardarContacto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        _imagenFile != null ? Colors.green : Colors.blue[300]!,
                    width: _imagenFile != null ? 3 : 2,
                  ),
                ),
                child: GestureDetector(
                  onTap: _mostrarOpcionesImagen,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue[50],
                    backgroundImage: _buildImageProvider(),
                    child: _buildImagePlaceholder(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _imagenFile != null
                    ? 'Imagen seleccionada ✓'
                    : 'Toca para seleccionar imagen',
                style: TextStyle(
                  color: _imagenFile != null ? Colors.green : Colors.blue[800],
                  fontSize: 14,
                  fontWeight:
                      _imagenFile != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _nombreController,
                label: 'Nombre',
                icon: Icons.person,
                validator:
                    (value) => value!.isEmpty ? 'Ingrese un nombre' : null,
              ),
              _buildTextFormField(
                controller: _apellidoController,
                label: 'Apellido',
                icon: Icons.person_outline,
                validator:
                    (value) => value!.isEmpty ? 'Ingrese un apellido' : null,
              ),
              _buildTextFormField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Ingrese un email';
                  if (!value.contains('@')) return 'Ingrese un email válido';
                  return null;
                },
              ),
              _buildTextFormField(
                controller: _telefonoController,
                label: 'Teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator:
                    (value) => value!.isEmpty ? 'Ingrese un teléfono' : null,
              ),
              _buildTextFormField(
                controller: _direccionController,
                label: 'Dirección',
                icon: Icons.location_on,
                validator:
                    (value) => value!.isEmpty ? 'Ingrese una dirección' : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.cake, color: Colors.blue[800]),
                title: const Text('Fecha de Nacimiento'),
                subtitle: Text(
                  '${_fechaNacimiento.day}/${_fechaNacimiento.month}/${_fechaNacimiento.year}',
                ),
                trailing: Icon(Icons.calendar_today, color: Colors.blue[800]),
                onTap: _seleccionarFecha,
              ),
              if (widget.contacto != null &&
                  context.read<AgendaCubit>().esContactoLocal(
                    widget.contacto!.id,
                  )) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    minimumSize: const Size(double.infinity, 50),
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
                                  style: TextStyle(color: Colors.blue[800]),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<AgendaCubit>().eliminarContacto(
                                    widget.contacto!.id,
                                  );
                                  Navigator.pop(context);
                                  Navigator.pop(context);
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
                  child: const Text(
                    'Eliminar Contacto',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              if (_guardando)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _buildImageProvider() {
    if (_imagenFile != null) {
      if (kIsWeb) {
        return NetworkImage(_imagenFile!.path);
      } else {
        return FileImage(File(_imagenFile!.path));
      }
    } else if (_imagenUrl.isNotEmpty) {
      if (_imagenUrl.startsWith('data:')) {
        try {
          return MemoryImage(base64Decode(_imagenUrl.split(',').last));
        } catch (e) {
          return null;
        }
      }
      return _imagenUrl.startsWith('http')
          ? NetworkImage(_imagenUrl)
          : (kIsWeb ? NetworkImage(_imagenUrl) : FileImage(File(_imagenUrl)));
    }
    return null;
  }

  Widget? _buildImagePlaceholder() {
    if (_imagenFile == null && _imagenUrl.isEmpty) {
      return Icon(Icons.camera_alt, size: 40, color: Colors.blue[800]);
    }
    return null;
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue[800]),
          prefixIcon: Icon(icon, color: Colors.blue[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
