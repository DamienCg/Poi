import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poi/pages/request.dart';
import 'package:poi/pages/maps.dart';
import 'package:poi/pages/settings.dart';
import 'maps.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState(1);
}

class _HomeState extends State<Home> {
  _HomeState(int index) {
    this.currentIndex = index;
  }

  int currentIndex = 0;

  List<Widget> pages = [
    RequestPage(),
    MapsPage(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("POI"),
        backgroundColor: Colors.deepPurple,
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page),
              label: "Request",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Maps",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ]),
      body: pages.elementAt(currentIndex),
    );
  }
}
