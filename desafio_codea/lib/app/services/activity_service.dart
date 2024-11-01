import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ActividadService {
  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/actividades.json');
  }

  Future<void> _crearArchivoInicial() async {
    final file = await _getLocalFile();
    if (!(await file.exists())) {
      // Crear un archivo JSON inicial con actividades vacías
      List<Map<String, dynamic>> actividadesIniciales = [
        {
          'nombre': 'Actividad 1',
          'descripcion': 'Descripción de la actividad 1',
          'horaInicio': null,
          'horaFin': null,
        },
        {
          'nombre': 'Actividad 2',
          'descripcion': 'Descripción de la actividad 2',
          'horaInicio': null,
          'horaFin': null,
        },
      ];
      // Convertir a JSON y guardar en el archivo
      String jsonString = jsonEncode(actividadesIniciales);
      await file.writeAsString(jsonString);
    }
  }

  Future<List<Map<String, dynamic>>> cargarActividades() async {
    await _crearArchivoInicial(); // Asegurarse de que el archivo inicial exista
    try {
      final file = await _getLocalFile();
      String jsonString = await file.readAsString();
      List<dynamic> jsonResponse = jsonDecode(jsonString);
      return jsonResponse.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      // Manejar errores al cargar el archivo
      return [];
    }
  }
}
