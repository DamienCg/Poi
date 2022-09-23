import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../location_service.dart';
import 'package:path_provider/path_provider.dart';

class MapsPage extends StatefulWidget {
  static double lat = 0;
  static double long = 0;
  static double Poilat = 0;
  static double Poilong = 0;
  static String PoiName = "";
  @override
  _MapsPageState createState() => _MapsPageState();
}

void getLocation() async {
  final service = await LocationService();
  final locationData = await service.getLocation();

  if (locationData != null) {
    MapsPage.lat = locationData.latitude!;
    MapsPage.long = locationData.longitude!;
  }

  await _read();
}

Future<String> _read() async {
  print("****1***");
  String text = "";
  final Directory directory = await getApplicationDocumentsDirectory();
  print("****1.1***");
  final File file = await File('${directory.path}/request.txt');
  print("****1.2***");
  text = await file.readAsString();
  print("Testo che sto leggendo da maps: " + text);
  MapsPage.Poilat = double.parse(text.split(",").first.replaceAll("[", ""));
  MapsPage.Poilong = double.parse(text.split(",")[1]);
  MapsPage.PoiName = text.split(",")[5];
  print("****2***");
  return MapsPage.PoiName;
}

List<Marker> ListOfMarkers = [
  new Marker(
      width: 45.0,
      height: 45.0,
      point: new LatLng(MapsPage.Poilat, MapsPage.Poilong),
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
                            title: Text(MapsPage.PoiName),
                          ));
                }),
          )),
  new Marker(
      width: 45.0,
      height: 45.0,
      point: new LatLng(MapsPage.lat, MapsPage.long),
      builder: (context) => new Container(
            child: IconButton(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.blueAccent,
                  size: 42,
                ),
                onPressed: () {
                  print('Marker tapped!');
                }),
          ))
];

class _MapsPageState extends State<MapsPage> {
  _MapsPageState() {}
  @override
  void initState() {
    print("****0*****");
    getLocation();
    print("****3***");
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
}
