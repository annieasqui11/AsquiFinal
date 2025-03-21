import 'package:flutter/material.dart';

class Navegacion with ChangeNotifier {
  int _paginaActual = 0;
  int get paginaActual => _paginaActual;

  void cambiarPagina(int nuevaPagina) {
    _paginaActual = nuevaPagina;

    notifyListeners();
  }
}
