import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('Materias');
  final List<Map<String, dynamic>> materias = [];
  final TextEditingController materiaController = TextEditingController();
  final TextEditingController nota1Controller = TextEditingController();
  final TextEditingController nota2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarMaterias();
  }

  void cargarMaterias() {
    setState(() {
      materias.clear();
    });
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, dynamic>> loadedMaterias = [];
        data.forEach((key, value) {
          loadedMaterias.add({
            'id': key,
            'materia': value['materia'],
            'nota1': value['nota1'],
            'nota2': value['nota2'],
          });
        });
        setState(() {
          materias.clear();
          materias.addAll(loadedMaterias);
        });
      }
    });
  }

  Future<void> agregarMateria() async {
    try {
      EasyLoading.show(
        status: 'Agregando',
        maskType: EasyLoadingMaskType.black,
      );
      final String materia = materiaController.text;
      final double? nota1 = double.tryParse(nota1Controller.text);
      final double? nota2 = double.tryParse(nota2Controller.text);

      if (materia.isNotEmpty &&
          nota1 != null &&
          nota2 != null &&
          nota1 >= 0 &&
          nota1 <= 10 &&
          nota2 >= 0 &&
          nota2 <= 10) {
        String materiaId = dbRef.push().key!;

        Map<String, dynamic> nuevoMateria = {
          'materia': materia,
          'nota1': nota1,
          'nota2': nota2,
        };

        await dbRef.child(materiaId).set(nuevoMateria);

        materiaController.clear();
        nota1Controller.clear();
        nota2Controller.clear();

        cargarMaterias();
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.showError('Error al agregar materia');
    }
  }

  Future<void> eliminarMateria(String id) async {
    try {
      await dbRef.child(id).remove();
      cargarMaterias(); // Recargar la lista después de eliminar la materia
    } catch (e) {
      EasyLoading.showError('Error al eliminar materia');
    }
  }

  double calcularPromedio() {
    if (materias.isEmpty) return 0.0;
    final total = materias.fold(
      0.0,
      (sum, item) => sum + ((item['nota1'] + item['nota2']) / 2),
    );
    return total / materias.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6E7),
      appBar: AppBar(
        title: Center(
          child: Text('MATERIAS', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Color(0xFF49868C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: materiaController,
              decoration: InputDecoration(labelText: 'Materia'),
            ),
            TextField(
              controller: nota1Controller,
              decoration: InputDecoration(labelText: 'Ciclo 1 (0-10)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: nota2Controller,
              decoration: InputDecoration(labelText: 'Ciclo 2 (0-10)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await agregarMateria();
              },
              child: Text('Agregar Materia'),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Materia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Ciclo 1', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Ciclo 2', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Promedio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz_outlined, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: materias.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              materias[index]['materia'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${materias[index]['nota1'].toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${materias[index]['nota2'].toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${((materias[index]['nota1'] + materias[index]['nota2']) / 2).toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await eliminarMateria(materias[index]['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 2),
            Text(
              'Promedio General: ${calcularPromedio().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
