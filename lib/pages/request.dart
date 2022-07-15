import 'package:flutter/material.dart';
import 'package:poi/location_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:poi/Controller/position.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final poiCategory = [
    'Historical Building',
    'Park',
    'Theater',
    'Museum',
    'Department'
  ];
  final rankPosition = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  String? value;
  String? value2;

  //location
  String? lat, long;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60), topRight: Radius.circular(60))),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey[200]!))),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Select POI Category: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: value,
                                  items:
                                      poiCategory.map(buildMenuItem).toList(),
                                  onChanged: (value) =>
                                      setState(() => this.value = value),
                                ),
                              ]),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey[200]!))),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Select Rank Position: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: value2,
                                  items:
                                      rankPosition.map(buildMenuItem).toList(),
                                  onChanged: (value) =>
                                      setState(() => this.value2 = value),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () => {SaveLatLong()},
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Go!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      );

  void getLocation() async {
    final service = LocationService();
    final locationData = await service.getLocation();

    if (locationData != null) {
      setState(() {
        //lat = locationData.latitude!.toStringAsFixed(4);
        //long = locationData.longitude!.toStringAsFixed(4);
        lat = locationData.latitude!.toString();
        long = locationData.longitude!.toString();
      });
    }
  }

  void SaveLatLong() {
    print(this.lat);
    print(this.long);
    _read();
  }

  Future<String> _read() async {
    String text = "";
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/settings.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Alert!"),
                content: Text("First you need to set your privacy preferences"),
              ));
    }
    print(text);
    Position position =
        new Position(double.parse(this.lat!), double.parse(this.long!));
    String privacyCategory = text.split(":").first;
    String privacydetail = text.split(":").last;
    if (privacyCategory == "GPS perturbation")
      position.Perturbation(privacydetail);
    if (privacyCategory == "Dummy update") position.Dummyupdate(privacydetail);
    return text;
  }
}
