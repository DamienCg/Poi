import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poi/location_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:poi/Controller/position.dart';
import 'package:poi/pages/home.dart';
import 'package:postgres/postgres.dart';
import 'dart:math' show cos, sqrt, asin;

import '../Controller/PositionRequest.dart';

_write(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/request.txt');
  await file.writeAsString(text);
}

String globalresponse = "";
String globalbestdistance = "";

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

Future<void> postgresConnect(
    String category, String rank, String positionAfterprivacy) async {
  if (category != null && rank != null) {
    final conn = await PostgreSQLConnection(
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
    var results = await conn.query(query);
    print("result query:" + results.toString());
    if (results.isEmpty) {
      print("SOLLEVATA?");
      throw new FormatException();
    } else {
      double bestDistance = 2000;
      results.forEach((element) {
        double currentDistance = calculateDistance(
            double.parse(element[0]),
            double.parse(element[1]),
            double.parse(positionAfterprivacy.split(":")[0]),
            double.parse(positionAfterprivacy.split(":")[1]));

        if (currentDistance < bestDistance) {
          bestDistance = currentDistance;
          globalresponse = element.toString();
          globalbestdistance = bestDistance.toString();
        }
      });

      await _write(globalresponse.toString());
    }
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

  Future<void> getLocation() async {
    final service = LocationService();
    final locationData = await service.getLocation();
    if (locationData != null) {
      setState(() {
        lat = locationData.latitude!.toString();
        long = locationData.longitude!.toString();
        PositionRequest.latitude = lat.toString();
        PositionRequest.Longitude = long.toString();
      });
    }
  }

  Future<void> SaveLatLong() async {
    try {
      await getLocation();
      await _read();
    } catch (e) {
      globalresponse = "";
      Future<void>.delayed(
          const Duration(
              milliseconds: 500), // OR const Duration(milliseconds: 500),
          () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Notice"),
                    content: Text("Nessun POI Trovato"),
                  )));
    }
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
      String globalresponse,
      String globalbestdistance) async {
    print("La risposta salvata su firebase è: " + globalresponse);
    DateTime dateTime = DateTime.now();
    await FirebaseFirestore.instance.collection('request').add({
      'Location Request After Privacy': locationrequest,
      'Poi Category': poicategory,
      'Privacy': privacy,
      'Privacy Details': privacyDetails,
      'Rank': rank,
      'DateTime': dateTime.toString(),
      'Response': globalresponse,
      'Real Location Request': lat! + ":" + long!
    });
  }

  Future<String> _read() async {
    print("Sono su read");
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
    if (this.lat == null || this.long == null) {
      getLocation();
    }
    Position position =
        new Position(double.parse(this.lat!), double.parse(this.long!));
    String privacyCategory = text.split(":").first;
    String privacydetail = text.split(":").last;
    if (privacyCategory == "GPS perturbation") {
      var positionAfterPertubation = position.Perturbation(privacydetail);
      await postgresConnect(value!, value2!, positionAfterPertubation);

      addRequestToFirebase(
          positionAfterPertubation,
          value!,
          privacyCategory,
          privacydetail,
          int.parse(value2!),
          globalresponse,
          globalbestdistance);
    }
    if (privacyCategory == "Dummy update") {
      var positionAfterDummy = position.Dummyupdate(privacydetail);
      await postgresConnect(value!, value2!, positionAfterDummy);

      addRequestToFirebase(
          positionAfterDummy,
          value!,
          privacyCategory,
          privacydetail,
          int.parse(value2!),
          globalresponse,
          globalbestdistance);
    }
    if (privacyCategory == "No privacy") {
      await postgresConnect(
          value!, value2!, lat.toString() + ":" + long.toString());

      addRequestToFirebase(
          lat!.toString() + ":" + long!.toString(),
          value!,
          privacyCategory,
          "",
          int.parse(value2!),
          globalresponse,
          globalbestdistance);
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
