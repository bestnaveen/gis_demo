import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:poc_demo/Screen/SubmitPayloadScreen.dart';
import 'Screen/QrScannerScreen.dart';

void main() {
  runApp(const MyApp());
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
  TextEditingController assetIdController = TextEditingController();
  TextEditingController qrValueController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController altitudeController = TextEditingController();
  String? latitude = '', longitude = '', altitude = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                controller: assetIdController,
                decoration: const InputDecoration(
                  label: Text("AssetId"),
                  hintText: 'Asset Id',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: qrValueController,
                decoration:  InputDecoration(
                  label: Text("QR Code"),
                  hintText: 'Scanned QR value',
                  suffixIcon: IconButton(onPressed: (){
                    _startScanner();
                  }, icon: Icon(Icons.qr_code)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: longitudeController,
                decoration:  InputDecoration(
                  hintText: 'Geo Location',
                  label: Text("Longitude"),
                  suffixIcon: IconButton(onPressed: (){
                    locationPermission();
                  }, icon: Icon(Icons.place_outlined)),
                ),
              ),
              if(longitudeController.text!=''&& latitudeController.text!=''&& altitudeController.text!='')TextField(
                controller: latitudeController,
                decoration:  InputDecoration(
                  hintText: 'Scanned QR value',
                    label: Text("Latitude"),
                  suffixIcon: IconButton(onPressed: (){

                  }, icon: Icon(Icons.place_outlined)),
                ),
              ),
              if(longitudeController.text!=''&& latitudeController.text!=''&& altitudeController.text!='') TextField(
                controller: altitudeController,
                decoration:  InputDecoration(
                  hintText: 'Scanned QR value',
                    label: Text("Altitude"),
                  suffixIcon: IconButton(onPressed: (){
                  }, icon: Icon(Icons.place_outlined)),
                ),
              ),

              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  submit();
                },
                child: const Text('Submit'),
              ),
            ],
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

  onQrAdded(String qrValue) {
    setState(() {
      qrValueController.text = qrValue;
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
    latitudeController.text = position.latitude.toString() ?? '';
    longitudeController.text = position.longitude.toString() ?? '';
    altitudeController.text = position.altitude.toString() ?? '';
    setState(() {});
  }

  resetAll() {
    assetIdController.clear();
    qrValueController.clear();
    latitude = '';
    longitude = '';
    altitude = '';
    setState(() {});
  }

  submit() async {
  var payload = {
      "ProjectId": "xyz",
      "ProjectCode": "string",
      "FeatureID": "string",
      "IsChainageBasis": "true",
      "CompanyId": "string",
      "data": [
        {
          "attributes": {
            "assetId": assetIdController.text.toString(),
            "qrCode": qrValueController.text.toString()
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

      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SubmitPayloadScreen(jsonEncode(payload),jsonDecode(response.body)),
      //   ),
      // );
      showSuccessDialog(jsonDecode(response.body));
    } else {
      print("Request failed with status: ${response.statusCode}");
      print(response.body);
    }
  } catch (e) {
    print("Error: $e");
  }

  }

  showSuccessDialog(dynamic res){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text("Success!!"),
            content:  Text(res),
            actions: <Widget>[
              MaterialButton(
                child: const Text("OK"),
                onPressed: () async {
                  Navigator.pop(context);
                  Geolocator.openLocationSettings();
                },
              ),
            ],
          );
        });
  }
}
