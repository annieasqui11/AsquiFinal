import 'package:academicoaa/inicio.dart';
import 'package:academicoaa/mapa.dart';
import 'package:academicoaa/navegacionProvider.dart';
import 'package:academicoaa/perfil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> with WidgetsBindingObserver {
  List<Widget> _paginas = [];

  List<BottomNavigationBarItem> _elementos = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _iniciarPantallas();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _iniciarPantallas() async {
    setState(() {
      _paginas = [Inicio(), mapa(), perfil()];

      _elementos = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        const BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_2_sharp),
          label: 'Perfil',
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final navegacionProvider = Provider.of<Navegacion>(context);

    final int paginaActual = navegacionProvider.paginaActual;

    if (_paginas.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: IndexedStack(index: paginaActual, children: _paginas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaActual,
        items: _elementos,
        onTap: (index) {
          navegacionProvider.cambiarPagina(index);
        },
        backgroundColor: Color(0xFF49868C),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
