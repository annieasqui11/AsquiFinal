import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> iniciarConGoogle() async {
    try {
      final GoogleSignInAccount? usuarioGoogle = await _googleSignIn.signIn();

      if (usuarioGoogle == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAutenticacion =
          await usuarioGoogle.authentication;

      final credenciales = GoogleAuthProvider.credential(
        accessToken: googleAutenticacion.accessToken,
        idToken: googleAutenticacion.idToken,
      );

      final UserCredential usuario = await _auth.signInWithCredential(
        credenciales,
      );

      return usuario.user;
    } catch (e) {
      print("El error es este: $e");
    }
    return null;
  }

  Future<void> _iniciar() async {
    try {
      //Iniciar un dialogo de carga
      EasyLoading.show(
        status: 'Iniciando...',
        maskType: EasyLoadingMaskType.black,
      );

      final usuario = await iniciarConGoogle();

      if (usuario == null) {
        EasyLoading.showError("Error al iniciar");
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('nombre', usuario!.displayName ?? 'SinNombre');
      await prefs.setString('correo', usuario.email ?? 'SinCorreo');
      await prefs.setString('foto', usuario.photoURL ?? 'SinFoto');
      await prefs.setString('id', usuario.uid);

      Navigator.pushReplacementNamed(context, '/principal');
    } catch (e) {
      //Si hay un error, mostrar un dialogo de error
      EasyLoading.showError('Error al iniciar sesión');
      print("El error es este: $e");
    } finally {
      //Cerrar el dialogo de carga
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F8F8),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                Image.asset("assets/Logo1.png", width: 200, height: 200),
                const SizedBox(height: 20),
                const Text(
                  "ACADÉMICO",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "INICIO SESIÓN",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            backgroundColor: const Color(0xFF49868C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            _iniciar();
                          },
                          child: const Text(
                            "Iniciar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "@ 2025 Anabel Asqui",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 2),
                Center(
                  child: Text(
                    "Todos los derechos reservados",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
