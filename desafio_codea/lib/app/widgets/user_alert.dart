import 'package:flutter/material.dart';

/// Popup que muestra los datos escaneados.
class AlertaPop extends StatelessWidget {
  final String conternido;
  final String nombreAlerta;

  ///
  const AlertaPop({
    super.key,
    required this.nombreAlerta,
    required this.conternido,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(nombreAlerta),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(conternido),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Aceptar', style: TextStyle(color: Colors.orange)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
