import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final privacyCategory = ['Dummy update', 'GPS perturbation', 'No privacy'];
  List<String> privacyCategoryOnCHange = [];
  String SecondElementPrivacy = " ";

  String? value;
  String? value2;

  void setprivacyCategoryOnCHange(item) {
    this.privacyCategoryOnCHange = item;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Select privacy settings:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: value,
                items: privacyCategory.map(buildMenuItem).toList(),
                onChanged: (value) => setState(() => this.value = value),
              ),
              SizedBox(height: 10),
              Text(SecondElementPrivacy,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 10),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: value2,
                items:
                    privacyCategoryOnCHange.map(buildMenuItemOnChange).toList(),
                onChanged: (value2) => setState(() => this.value2 = value2),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () => {},
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
              SizedBox(height: 150),
              Text(
                'Signed in as: ' + user.email!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueGrey),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () => FirebaseAuth.instance.signOut(),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Sign Out',
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
      );

  DropdownMenuItem<String> buildMenuItem(String item) {
    var ret = DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );

    if (value == "Dummy update") {
      this.SecondElementPrivacy = "Select Number of dummy update";
      setprivacyCategoryOnCHange(["1", "2", "3", "4"]);
    } else if (value == "GPS perturbation") {
      this.SecondElementPrivacy = "Select Perturbation digit";
      setprivacyCategoryOnCHange(["altro1", "altro2", "altro3"]);
    } else {
      this.SecondElementPrivacy = "Ok, No privacy, let's go! ";
    }
    return ret;
  }

  DropdownMenuItem<String> buildMenuItemOnChange(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
