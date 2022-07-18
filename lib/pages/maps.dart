import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../location_service.dart';

class MapsPage extends StatefulWidget {
  static double lat = 0;
  static double long = 0;
  @override
  _MapsPageState createState() => _MapsPageState();
}

void getLocation() async {
  final service = LocationService();
  final locationData = await service.getLocation();

  if (locationData != null) {
    MapsPage.lat = locationData.latitude!;
    MapsPage.long = locationData.longitude!;
  }
}

class _MapsPageState extends State<MapsPage> {
  _MapsPageState() {
    getLocation();
  }
  List<Marker> ListOfMarkers = [
    /*
    new Marker(
        width: 45.0,
        height: 45.0,
        point: new LatLng(44.50, 11.33),
        builder: (context) => new Container(
              child: IconButton(
                  icon: Icon(
                    Icons.add_location_alt_rounded,
                    color: Colors.deepPurple,
                    size: 32,
                  ),
                  onPressed: () {
                    print('Marker tapped!');
                  }),
            )),
            */
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
