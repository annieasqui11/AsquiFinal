import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaCarga extends StatefulWidget {
  @override
  _PantallaCargaState createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  @override
  void initState() {
    super.initState();
    _inicio();
  }

  Future<void> _inicio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? dato = prefs.getString('id');

    if (dato != null) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/principal');
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  Future<void> _logica() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Logo1.png', width: 200, height: 200),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                "CARGANDO",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
