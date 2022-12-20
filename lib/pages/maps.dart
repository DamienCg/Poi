import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../location_service.dart';
import 'package:path_provider/path_provider.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

double lat = 0;
double long = 0;
double Poilat = 0;
double Poilong = 0;
String PoiName = "";
List<Marker> ListOfMarkers = List.empty(growable: true);

Future<void> getLocation() async {
  final service = LocationService();
  final locationData = await service.getLocation();

  if (locationData != null) {
    lat = locationData.latitude!;
    long = locationData.longitude!;
  }
}

Future<String> _read() async {
  String text = "";
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = await File('${directory.path}/request.txt');
  text = await file.readAsString();
  Poilat = double.parse(text.split(",").first.replaceAll("[", ""));
  Poilong = double.parse(text.split(",")[1]);
  PoiName = text.split(",")[5];
  return PoiName;
}

class _MapsPageState extends State<MapsPage> {
  _MapsPageState() {}
  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: <Widget>[
            new FlutterMap(
                options: new MapOptions(
                    minZoom: 10.0, center: new LatLng(44.49, 11.34)),
                layers: [
                  new TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  new MarkerLayerOptions(markers: ListOfMarkers)
                ])
          ],
        ),
      );

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );

  Future<void> createMarker() async {
    ListOfMarkers = [
      new Marker(
          width: 45.0,
          height: 45.0,
          point: new LatLng(Poilat, Poilong),
          builder: (context) => new Container(
                child: IconButton(
                    icon: Icon(
                      Icons.add_location_alt_rounded,
                      color: Colors.deepPurple,
                      size: 32,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(PoiName),
                              ));
                    }),
              )),
      new Marker(
          width: 45.0,
          height: 45.0,
          point: new LatLng(lat, long),
          builder: (context) => new Container(
                child: IconButton(
                    icon: Icon(
                      Icons.person_pin,
                      color: Colors.blueAccent,
                      size: 42,
                    ),
                    onPressed: () {
                      print('Me');
                    }),
              ))
    ];
  }

  Future<void> start() async {
    try {
      await getLocation();
      await _read();
      await createMarker();
    } catch (e) {
      print(e);
    }
    setState(() {});
  }
}
