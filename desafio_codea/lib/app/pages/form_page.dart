import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'activity_screen.dart';

class FormTask extends StatefulWidget {
  final List<Map<String, dynamic>> actividades;

  const FormTask({Key? key, required this.actividades}) : super(key: key);

  @override
  _FormTaskState createState() => _FormTaskState();
}

class _FormTaskState extends State<FormTask> {
  final Map<int, TimeOfDay?> _horaInicio = {};
  final Map<int, TimeOfDay?> _horaFin = {};
  late Connectivity _connectivity;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _checkInitialConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus as void
        Function(List<ConnectivityResult> event)?);
  }

  Future<void> _checkInitialConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult as ConnectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    bool wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;

    if (_isConnected && !wasConnected) {
      _sincronizarActividades();
    }
  }

  Future<void> _seleccionarHoraInicio(int index) async {
    TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horaSeleccionada != null) {
      setState(() {
        _horaInicio[index] = horaSeleccionada;
      });
    }
  }

  Future<void> _seleccionarHoraFin(int index) async {
    TimeOfDay? horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (horaSeleccionada != null) {
      if (_horaInicio[index] != null &&
          (horaSeleccionada.hour < _horaInicio[index]!.hour ||
              (horaSeleccionada.hour == _horaInicio[index]!.hour &&
                  horaSeleccionada.minute < _horaInicio[index]!.minute))) {
        _mostrarError("La hora de fin debe ser después de la hora de inicio.");
        return;
      }
      setState(() {
        _horaFin[index] = horaSeleccionada;
      });
    }
  }

  String formatHora(TimeOfDay? time) {
    if (time == null) return "No seleccionado";
    final now = DateTime.now();
    final format = DateFormat.jm();
    return format
        .format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/actividades.json');
  }

  Future<void> _guardarActividadesLocalmente() async {
    final file = await _getLocalFile();
    List<Map<String, dynamic>> actividadesGuardadas = [];

    for (int i = 0; i < widget.actividades.length; i++) {
      actividadesGuardadas.add({
        'nombre': widget.actividades[i]['nombre'],
        'descripcion': widget.actividades[i]['descripcion'],
        'horaInicio': _horaInicio[i]?.format(context),
        'horaFin': _horaFin[i]?.format(context),
      });
    }

    String jsonString = jsonEncode(actividadesGuardadas);
    await file.writeAsString(jsonString);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Actividades guardadas localmente')),
    );
  }

  Future<void> _sincronizarActividades() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        String jsonString = await file.readAsString();
        List actividadesGuardadas = jsonDecode(jsonString);
        for (var actividad in actividadesGuardadas) {
          await _enviarActividadAlServidor(actividad);
        }
        await file.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Actividades sincronizadas con el servidor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al sincronizar con el servidor')),
      );
    }
  }

  Future<void> _enviarActividadAlServidor(
      Map<String, dynamic> actividad) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Formulario de Tareas",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange,
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.actividades.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.actividades[index]['nombre'] ??
                                'Actividad sin nombre',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "Descripción: ${widget.actividades[index]['descripcion'] ?? 'Sin descripción'}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text("Hora de inicio"),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _seleccionarHoraInicio(index),
                                      child:
                                          Text(formatHora(_horaInicio[index])),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text("Hora de fin"),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _seleccionarHoraFin(index),
                                      child: Text(formatHora(_horaFin[index])),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_isConnected) {
            await _sincronizarActividades();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ActividadesScreen()),
            );
          } else {
            await _guardarActividadesLocalmente();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ActividadesScreen()),
            );
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.save, color: Colors.white),
        tooltip: 'Guardar Actividades',
      ),
    );
  }
}
