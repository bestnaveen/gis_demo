import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:poc_demo/Provider/AppProvider.dart';
import 'package:poc_demo/Screen/FormScreen.dart';
import 'package:poc_demo/Screen/SettingScreen.dart';
import 'package:poc_demo/Screen/SubmitPayloadScreen.dart';
import 'Screen/QrScannerScreen.dart';

void main() {
  runApp(AppProvider());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: FormScreen(),
    );
  }
}


