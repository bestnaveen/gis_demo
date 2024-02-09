
import 'package:flutter/material.dart';
import 'package:gis_demo/Screen/FormScreen.dart';

import 'Provider/AppProvider.dart';



void main() {
  runApp(const AppProvider());
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


