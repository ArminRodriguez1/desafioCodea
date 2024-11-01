class ActivityTestService {
  Future<List<Map<String, dynamic>>> cargarActividades() async {
    return [
      {
        'nombre': 'Actividad 1',
        'descripcion': 'Descripción de actividad 1',
        'horaInicio': '10:00 AM',
        'horaFin': '11:00 AM',
      },
      {
        'nombre': 'Actividad 2',
        'descripcion': 'Descripción de actividad 2',
        'horaInicio': '12:00 PM',
        'horaFin': '1:00 PM',
      },
    ];
  }
}
