import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<Settings> {
  final user = FirebaseAuth.instance.currentUser!;
  String _selectedCountry = "No privacy";
  String SecondElementPrivacy = "Ok, No privacy, let's go! ";

  var privacy = {
    'No privacy': 'NP',
    'Dummy update': 'DU',
    'GPS perturbation': 'GPSP'
  };

  List _countries = [];
  CountryDependentDropDown() {
    privacy.forEach((key, value) {
      _countries.add(key);
    });
  }

  String _selectedState = "Nothing to select";
  var state = {
    'Nothing to select': 'NP',
    '1': 'DU',
    '2': 'DU',
    '3': 'DU',
    '4': 'DU',
    '5': 'DU',
    'altro': 'GPSP',
    'altro1': 'GPSP',
    'altro2': 'GPSP',
    'altro3': 'GPSP',
  };

  List _states = [];
  StateDependentDropDown(countryShortName) {
    if (countryShortName == "NP") {
      this.SecondElementPrivacy = "Ok, No privacy, let's go! ";
    }
    if (countryShortName == "DU") {
      this.SecondElementPrivacy = "Select number of dummy update";
    }
    if (countryShortName == "GPSP")
      this.SecondElementPrivacy = "Select Perturbation digit";

    state.forEach((key, value) {
      if (countryShortName == value) {
        _states.add(key);
      }
    });
    _selectedState = _states[0];
  }

  @override
  void initState() {
    super.initState();
    CountryDependentDropDown();
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
                value: _selectedCountry,
                onChanged: (newValue) {
                  setState(() {
                    _states = [];
                    StateDependentDropDown(privacy[newValue]);
                    _selectedCountry = "$newValue";
                  });
                },
                items: _countries.map((country) {
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
                value: _selectedState,
                onChanged: (newValue) {
                  setState(() {
                    _selectedState = "$newValue";
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
    print(this._selectedCountry);
    print(this._selectedState);
  }
}
