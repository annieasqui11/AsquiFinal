import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class mapa extends StatefulWidget {
  @override
  _mapaState createState() => _mapaState();
}

class _mapaState extends State<mapa> {
  GoogleMapController? _controller;
  static const LatLng _defaultLocation = LatLng(-1.656974, -78.6801592);
  static const double _defaultZoom = 15.0;

  String ciudad = 'Riobamba';
  double latitud = -1.656974;
  double longitud = -78.6801592;
  String temperatura = '';
  String viento = '';
  bool isLoading = false;
  Set<Marker> _markers = {};

  Future<void> obtenerClima() async {
    setState(() {
      isLoading = true;
    });

    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitud&longitude=$longitud&current_weather=true';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          temperatura =
              data['current_weather']['temperature'].toString() + '°C';
          viento = data['current_weather']['windspeed'].toString() + ' km/h';
          isLoading = false;
        });
      } else {
        throw Exception('No se pudo obtener el clima');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener el clima: $e');
    }
  }

  Future<void> obtenerUbicacion() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitud = position.latitude;
      longitud = position.longitude;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId("ubicacion"),
          position: LatLng(latitud, longitud),
          infoWindow: InfoWindow(title: "Tu ubicación actual"),
        ),
      );
    });

    _controller?.animateCamera(
      CameraUpdate.newLatLng(LatLng(latitud, longitud)),
    );
    obtenerClima();
  }

  @override
  void initState() {
    super.initState();
    obtenerClima();
    obtenerUbicacion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6E7),
      appBar: AppBar(
        title: const Center(
          child: Text('MAPA', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Color(0xFF49868C),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CLIMA ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: obtenerClima, // Refrescar clima
                      ),
                    ],
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : Text(
                        '$ciudad, $temperatura; Viento: $viento',
                        style: TextStyle(fontSize: 15),
                      ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  initialCameraPosition: const CameraPosition(
                    target: _defaultLocation,
                    zoom: _defaultZoom,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.my_location, color: Colors.white),
                    onPressed: obtenerUbicacion,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
