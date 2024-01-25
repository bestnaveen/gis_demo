
import 'package:flutter/material.dart';

import 'package:poc_demo/Provider/AppProvider.dart';
import 'package:poc_demo/Screen/FormScreen.dart';

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


