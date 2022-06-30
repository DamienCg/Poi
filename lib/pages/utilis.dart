import 'package:flutter/material.dart';

class UtilisShape {
  static ElevatedButton button = new ElevatedButton(
    child: Text('Go!'),
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        primary: Colors.orange[900],
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  );
}
