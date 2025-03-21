import 'package:academicoaa/navegacionProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class perfil extends StatefulWidget {
  @override
  _perfilState createState() => _perfilState();
}

class _perfilState extends State<perfil> {
  String? userId;
  String? nombre;
  String? correo;
  String? usuario;
  String? foto;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('uid');
      nombre = prefs.getString('nombre');
      correo = prefs.getString('correo');
      foto = prefs.getString('foto');
    });
  }

  Future<void> _cerrarSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    await _auth.signOut();
    await _googleSignIn.signOut();
    EasyLoading.showSuccess('Sesión cerrada');

    // Redirigir a la pantalla de inicio de sesión o cualquier otra pantalla deseada
    Provider.of<Navegacion>(context, listen: false).cambiarPagina(0);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // Nombre de la ruta a la pantalla de inicio de sesión
      (route) => false, // Eliminar todas las rutas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6E7),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PERFIL DE USUARIO',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xFF49868C),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF49868C), width: 5),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        foto ?? 'https://i.imgur.com/0WD5tEo.jpeg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Card(
                  elevation: 4, // Sombra
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Datos',
                            style: TextStyle(
                              color: Color(0xFF49868C),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildProfileRow('Nombre:', nombre),
                        Divider(color: Colors.grey[300], thickness: 1),
                        _buildProfileRow('Correo:', correo),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                      backgroundColor: Color(0xFF49868C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _cerrarSesion();
                    },
                    child: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Función para construir filas de datos
  Widget _buildProfileRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF49868C),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'No disponible',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
