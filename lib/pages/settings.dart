import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<Settings> {
  final user = FirebaseAuth.instance.currentUser!;
  String _selectedPrivacy = "No privacy";
  String SecondElementPrivacy = "Ok, No privacy, let's go! ";

  var privacy = {
    'No privacy': 'NP',
    'Dummy update': 'DU',
    'GPS perturbation': 'GPSP'
  };

  List _listprivacy = [];
  privacyDependentDropDown() {
    privacy.forEach((key, value) {
      _listprivacy.add(key);
    });
  }

  String privacyDetails = "Nothing to select";
  var state = {
    'Nothing to select': 'NP',
    '5': 'DU',
    '10': 'DU',
    '15': 'DU',
    '20': 'DU',
    '25': 'DU',
    '0': 'GPSP',
    '1': 'GPSP',
    '2': 'GPSP',
  };

  List _states = [];
  privacy2DependentDropDown(privacyShortName) {
    if (privacyShortName == "NP") {
      this.SecondElementPrivacy = "Ok, No privacy, let's go! ";
    }
    if (privacyShortName == "DU") {
      this.SecondElementPrivacy = "Select number of dummy update";
    }
    if (privacyShortName == "GPSP")
      this.SecondElementPrivacy = "Select Perturbation digit";

    state.forEach((key, value) {
      if (privacyShortName == value) {
        _states.add(key);
      }
    });
    privacyDetails = _states[0];
  }

  @override
  void initState() {
    super.initState();
    privacyDependentDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 23,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select privacy settings:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Container(
              width: 400,
              child: DropdownButton(
                value: _selectedPrivacy,
                onChanged: (newValue) {
                  setState(() {
                    _states = [];
                    privacy2DependentDropDown(privacy[newValue]);
                    _selectedPrivacy = "$newValue";
                  });
                },
                items: _listprivacy.map((country) {
                  return DropdownMenuItem(
                    child: new Text(country),
                    value: country,
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 23,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  SecondElementPrivacy,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
            Container(
              width: 400,
              child: DropdownButton(
                value: privacyDetails,
                onChanged: (newValue) {
                  setState(() {
                    privacyDetails = "$newValue";
                  });
                },
                items: _states.map((state) {
                  return DropdownMenuItem(
                    child: new Text(state),
                    value: state,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () => {SaveSettings()},
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Save',
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
            SizedBox(height: 170),
            Text(
              'Signed in as: ' + user.email!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void SaveSettings() {
    _write(this._selectedPrivacy + ":" + this.privacyDetails);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Saved"),
            ));
  }

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/settings.txt');
    await file.writeAsString(text);
  }
}
