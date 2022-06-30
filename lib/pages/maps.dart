//ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:poi/pages/utilis.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Marker> ListOfMarkers = [
    new Marker(
        width: 45.0,
        height: 45.0,
        point: new LatLng(44.50, 11.33),
        builder: (context) => new Container(
              child: IconButton(
                  icon: Icon(Icons.add_location_alt_outlined),
                  onPressed: () {
                    print('Marker tapped!');
                  }),
            )),
    new Marker(
        width: 45.0,
        height: 45.0,
        point: new LatLng(44.49, 11.31),
        builder: (context) => new Container(
              child: IconButton(
                  icon: Icon(Icons.add_location_alt_outlined),
                  onPressed: () {
                    print('Marker tapped!');
                  }),
            ))
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: <Widget>[
            UtilisShape.button,
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
