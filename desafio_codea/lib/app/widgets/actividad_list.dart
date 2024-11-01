import 'package:flutter/material.dart';

class ActividadList extends StatelessWidget {
  final List<Map<String, dynamic>> actividades;

  const ActividadList({Key? key, required this.actividades}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: actividades.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actividades[index]['nombre'] ?? 'Actividad sin nombre',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Descripción: ${actividades[index]['descripcion'] ?? 'Sin descripción'}"),
                const SizedBox(height: 8),
                Text("Hora de inicio: ${actividades[index]['horaInicio'] ?? 'No especificada'}"),
                const SizedBox(height: 4),
                Text("Hora de fin: ${actividades[index]['horaFin'] ?? 'No especificada'}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
