import 'package:flutter/material.dart';
import 'package:desafio_codea/app/routes.dart';
import 'package:desafio_codea/app/pages/login.dart';
import 'app/services/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final connectivityService = ConnectivityService();
  connectivityService.startListening();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.getRoutes,
      navigatorObservers: [Routes.routeObserver],
    );
  }
}
