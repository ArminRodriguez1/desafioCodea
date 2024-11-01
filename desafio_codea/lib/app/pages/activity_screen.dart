import 'package:flutter/material.dart';
import '../services/activity_service.dart';
import '../widgets/actividad_list.dart';
import '../widgets/action_bar.dart';

class ActividadesScreen extends StatefulWidget {
  const ActividadesScreen({Key? key}) : super(key: key);

  @override
  _ActividadesScreenState createState() => _ActividadesScreenState();
}

class _ActividadesScreenState extends State<ActividadesScreen> {
  List<Map<String, dynamic>> _actividades = [];
  final ActividadService _actividadService = ActividadService();

  @override
  void initState() {
    super.initState();
    _cargarActividades();
  }

  Future<void> _cargarActividades() async {
    _actividades = await _actividadService.cargarActividades();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Actividades", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        actions: [
          ActionBar(onReload: _cargarActividades),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _actividades.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ActividadList(actividades: _actividades),
      ),
    );
  }
}
