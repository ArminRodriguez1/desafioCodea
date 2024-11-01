import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  void startListening() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _sendSavedActivities();
      }
    } as void Function(List<ConnectivityResult> event)?)
            as StreamSubscription<ConnectivityResult>?;
  }

  Future<void> _sendSavedActivities() async {
    final file = await _getLocalFile();

    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> actividades = jsonDecode(contents);

      for (var actividad in actividades) {
        try {
          final response = await http.post(
            Uri.parse('https://tu-servidor.com/api/actividades'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(actividad),
          );

          if (response.statusCode == 200) {
            print('Actividad enviada: ${actividad['nombre']}');
          }
        } catch (e) {
          print('Error al enviar actividad: $e');
        }
      }
      await file.writeAsString('[]');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/actividades.json');
  }

  void stopListening() {
    _connectivitySubscription?.cancel();
  }
}
