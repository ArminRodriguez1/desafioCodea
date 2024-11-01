import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../pages/form_page.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  List<Map<String, dynamic>> actividades = [];

  Future<void> leerQR(BuildContext context) async {
    final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#FF6A00',
      'Cancelar',
      false,
      ScanMode.QR,
    );

    if (barcodeScanRes != '-1') {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(barcodeScanRes);
        mostrarFormularioTareas(context, jsonData);
      } catch (e) {
        mostrarError(context, 'Código QR no válido o datos incorrectos');
      }
    }
  }

  void mostrarFormularioTareas(BuildContext context, Map<String, dynamic> datos) {
    final formularios = datos['formularios'] as List<dynamic>?;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Seleccione un formulario de tareas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 10),
              if (formularios != null && formularios.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: formularios.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.article, color: Colors.orange),
                      title: Text(formularios[index]['nombre']),
                      subtitle: Text(formularios[index]['descripcion']),
                      onTap: () {
                        Navigator.pop(context);
                        abrirFormulario(context, formularios[index]);
                      },
                    );
                  },
                )
              else
                const Text(
                  'No se encontraron formularios asociados.',
                  style: TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void abrirFormulario(BuildContext context, Map<String, dynamic> formulario) {
    List<Map<String, dynamic>> actividadesFormulario = formulario['actividades'] != null
        ? List<Map<String, dynamic>>.from(formulario['actividades'])
        : [];

    setState(() {
      actividades = actividadesFormulario;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormTask(actividades: actividades),
      ),
    );
  }

  void mostrarError(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.orange,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.qr_code, size: 35.0, color: Colors.white),
                onPressed: () {
                  leerQR(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('Precione el icono para comenzar a escanear.'),
      ),
    );
  }
}
