import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:poc_demo/Screen/SettingScreen.dart';
import 'package:poc_demo/Screen/SubmitPayloadScreen.dart';
import 'Screen/QrScannerScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingScreenProvider(),
      child: const MyApp(),
    ),
  );
}


class SettingScreenProvider with ChangeNotifier {
  TextEditingController assetIdController = TextEditingController();
  TextEditingController qrValueController = TextEditingController();
  TextEditingController projectIdController = TextEditingController();
  TextEditingController projectCodeController = TextEditingController();
  TextEditingController featureIDController = TextEditingController();
  TextEditingController isChainageBasisController = TextEditingController();
  TextEditingController companyIdController = TextEditingController();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TextEditingController assetIdController = TextEditingController();
  // TextEditingController qrValueController = TextEditingController();
  String? latitude = '', longitude = '', altitude = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
              onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingScreen()));
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<SettingScreenProvider>(
            builder: (context, textFieldProvider, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            resetAll();
                          },
                          child: Text('Reset All'))),
                  TextField(
                    controller: textFieldProvider.assetIdController,
                    decoration: const InputDecoration(
                      hintText: 'Asset Id',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: textFieldProvider.qrValueController,
                    decoration: const InputDecoration(
                      hintText: 'Scanned QR value',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _startScanner();
                    },
                    child: const Text('QR CODE DATA'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (latitude == '' && longitude == '')
                    const Text(
                        'Click on the Fetch location button to get Geolocation'),
                  ElevatedButton(
                    onPressed: () {
                      locationPermission();
                    },
                    child: const Text('Fetch GeoLocation'),
                  ),
                  if (latitude != '') Text('Latitude: $latitude'),
                  if (longitude != '') Text('Longitude: $longitude'),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  void _startScanner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerScreen(onQrAdded),
      ),
    );
  }

  onQrAdded(String qrValue, SettingScreenProvider textFieldProvider) {
    setState(() {
      textFieldProvider.qrValueController.text = qrValue;
    });
  }

  void locationPermission() async {
    // controller?.animateBack(0,
    // duration: const Duration(milliseconds: 600), curve: Curves.bounceOut);
    // isLoading.value = true;
    LocationPermission permission1 = await Geolocator.checkPermission();
    if (permission1 == LocationPermission.denied) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showAlertDialog();
        // isLoading.value = false;
        // controller?.forward();
      } else if (permission == LocationPermission.deniedForever) {
        showAlertDialog();
        // isLoading.value = false;
        // controller?.forward();
      } else {
        getCoordinates();
      }
    } else {
      getCoordinates();
    }
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text("Alert!!"),
            content: const Text(
                "You need to provide the Location access forGeo coordinates"),
            actions: <Widget>[
              MaterialButton(
                child: const Text("OK"),
                onPressed: () async {
                  Navigator.pop(context);
                  Geolocator.openLocationSettings();
                },
              ),
              MaterialButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  getCoordinates() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude.toString() ?? '';
    longitude = position.longitude.toString() ?? '';
    altitude = position.altitude.toString() ?? '';
    setState(() {});
  }

  resetAll(SettingScreenProvider textFieldProvider) {
    textFieldProvider.assetIdController.clear();
    textFieldProvider.qrValueController.clear();
    latitude = '';
    longitude = '';
    altitude = '';
    setState(() {});
  }

  submit(SettingScreenProvider textFieldProvider) async {
  var payload = {
      "ProjectId": "xyz",
      "ProjectCode": "string",
      "FeatureID": "string",
      "IsChainageBasis": "true",
      "CompanyId": "string",
      "data": [
        {
          "attributes": {
            "assetId": textFieldProvider.assetIdController.text.toString(),
            "qrCode": textFieldProvider.qrValueController.text.toString()
          },
          "coordinates": [
            {"x": longitude, "y": latitude, "z": altitude}
          ]
        }
      ]
    };
    String url = 'https://entgissync.pipetrakit.com/api/GISSync/SyncObject';
  try {
    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(payload),  // Encode the payload as JSON
      headers: {
        "Content-Type": "application/json", // Set content type to JSON
      },
    );

    // Check the response status code
    if (response.statusCode == 200) {
      print("Request successful");
      print(response.body);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubmitPayloadScreen(jsonEncode(payload),jsonDecode(response.body)),
        ),
      );
    } else {
      print("Request failed with status: ${response.statusCode}");
      print(response.body);
    }
  } catch (e) {
    print("Error: $e");
  }

  }
}
