import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poi/location_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:poi/Controller/position.dart';
import 'package:poi/pages/home.dart';
import 'package:postgres/postgres.dart';

_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/request.txt');
  await file.writeAsString(text);
  print("Stro scrivendo:" + text);
}

void postgresConnect(String category, String rank) async {
  if (category != null && rank != null) {
    final conn = PostgreSQLConnection(
      '10.0.2.2',
      5432,
      'postgres',
      username: 'postgres',
      password: '9964',
    );
    await conn.open();
    String query = 'select * from ' +
        category.toLowerCase() +
        ' x' +
        ' where x."rank" >= ' +
        rank;
    print(query);
    var results = await conn.query(query);
    print(results);
    _write(results.toString());
    await conn.close();
  }
}

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final poiCategory = [
    'Historical',
    'Park',
    'Theater',
    'Museum',
    'Departement'
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
        lat = locationData.latitude!.toString();
        long = locationData.longitude!.toString();
      });
    }
  }

  void SaveLatLong() {
    _read();
    Home homeMaps = new Home();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => homeMaps));
  }

  // SALVO i dati su firebase!
  Future addRequestToFirebase(
    String locationrequest,
    String poicategory,
    String privacy,
    String privacyDetails,
    int rank,
  ) async {
    DateTime dateTime = DateTime.now();
    await FirebaseFirestore.instance.collection('request').add({
      'Location Request': locationrequest,
      'Poi Category': poicategory,
      'Privacy': privacy,
      'Privacy Details': privacyDetails,
      'Rank': rank,
      'DateTime': dateTime.toString(),
    });
  }

  Future<String> _read() async {
    postgresConnect(value!, value2!);
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
    Position position =
        new Position(double.parse(this.lat!), double.parse(this.long!));
    String privacyCategory = text.split(":").first;
    String privacydetail = text.split(":").last;
    if (privacyCategory == "GPS perturbation") {
      addRequestToFirebase(position.Perturbation(privacydetail), value!,
          privacyCategory, privacydetail, int.parse(value2!));
    }
    if (privacyCategory == "Dummy update") {
      addRequestToFirebase(position.Dummyupdate(privacydetail), value!,
          privacyCategory, privacydetail, int.parse(value2!));
    }
    if (privacyCategory == "No privacy") {
      addRequestToFirebase(
          "[ \"" + lat!.toString() + "-" + long!.toString() + "\"]",
          value!,
          privacyCategory,
          "",
          int.parse(value2!));
    }

    return text;
  }

  void showThings() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Nothig to Show"),
            ));
  }
}
