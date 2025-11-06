import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle(){
    return  TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins');

  }
   static TextStyle semiboldTextFieldStyle(){
    return  TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins');

  }
    static TextStyle HeaderTextFieldStyle(){
    return  TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins');

  }
     static TextStyle lightTextFieldStyle(){
    return  TextStyle(
                color: Color.fromARGB(255, 180, 69, 69),
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins');

  }
}