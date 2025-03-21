import 'package:academicoaa/firebase_options.dart';
import 'package:academicoaa/login.dart';
import 'package:academicoaa/navegacionProvider.dart';
import 'package:academicoaa/pantallacarga.dart';
import 'package:academicoaa/principal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());

  runApp(
    ChangeNotifierProvider(create: (context) => Navegacion(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          secondary: Colors.blue,
        ),
        useMaterial3: true,
      ),
      //home: Pantallacarga(),
      initialRoute: '/',
      routes: {
        '/': (context) => PantallaCarga(),
        '/login': (context) => InicioSesion(),
        '/principal': (context) => Principal(),
      },
      builder: EasyLoading.init(),
    );
  }
}
