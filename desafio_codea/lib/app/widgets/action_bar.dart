import 'package:flutter/material.dart';
import '../pages/login.dart';
import '../pages/qr_scanner_screen.dart';
import 'excel_exporter.dart';

class ActionBar extends StatelessWidget {
  final Function onReload;

  const ActionBar({Key? key, required this.onReload}) : super(key: key);

  void _cerrarSesion(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var excelCreator = ExcelCreator();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _cerrarSesion(context),
          tooltip: 'Cerrar sesión',
        ),
        Column(
          children: [
            FloatingActionButton(
              heroTag: "addButton",
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerScreen()),
                ).then((_) => onReload());
              },
            ),
            const SizedBox(height: 16),
            FloatingActionButton.extended(
              heroTag: "downloadButton",
              backgroundColor: Colors.green,
              icon: const Icon(Icons.file_download),
              label: const Text("Descargar"),
              onPressed: () async {
              },
            ),
          ],
        ),
      ],
    );
  }
}
