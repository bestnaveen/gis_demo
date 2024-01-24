import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../Provider/SettingProvider.dart';
import 'QrScannerScreen.dart';
import 'SettingScreen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key,});
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController assetIdController = TextEditingController();
  TextEditingController qrValueController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController altitudeController = TextEditingController();
  String? latitude = '', longitude = '', altitude = '';

  SettingScreenProvider textFieldProvider = SettingScreenProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GIS SYNC DEMO'),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () {
                        resetAll(textFieldProvider: textFieldProvider);
                      },
                      child: const Text('Reset All'))),
              TextField(
                controller: textFieldProvider.assetIdController,
                decoration: const InputDecoration(
                  label: Text("AssetId"),
                  hintText: 'Asset Id',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textFieldProvider.qrValueController,
                decoration:  InputDecoration(
                  label: const Text("QR Code"),
                  hintText: 'Scanned QR value',
                  suffixIcon: IconButton(onPressed: (){
                    _startScanner();
                  }, icon: const Icon(Icons.qr_code)),
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
                  label: const Text("Altitude"),
                  suffixIcon: IconButton(onPressed: (){
                  }, icon: const Icon(Icons.place_outlined)),
                ),
              ),

              const SizedBox(
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
    latitudeController.text = position.latitude.toString() ?? '';
    longitudeController.text = position.longitude.toString() ?? '';
    altitudeController.text = position.altitude.toString() ?? '';
    setState(() {});
  }

  resetAll({SettingScreenProvider? textFieldProvider}) {
    textFieldProvider?.assetIdController.clear();
    textFieldProvider?.qrValueController.clear();
    latitude = '';
    longitude = '';
    altitude = '';
    setState(() {});
  }

  submit({SettingScreenProvider? textFieldProvider}) async {
    var payload = {
      "ProjectId": "xyz",
      "ProjectCode": "string",
      "FeatureID": "string",
      "IsChainageBasis": false,
      "CompanyId": "string",
      "data": [
        {
          "attributes": {
            "assetId": textFieldProvider?.assetIdController.text.toString(),
            "qrCode": textFieldProvider?.qrValueController.text.toString()
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
        body: jsonEncode(payload),
        headers: {
          "Content-Type": "application/json",
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

  showSuccessDialog(dynamic res) {
    showDialog(
      context: context,
      builder: (context) {
        if (res != null &&
            res is Map<String, dynamic> &&
            res.containsKey('Status') &&
            res['Status'] is Map<String, dynamic> &&
            res['Status'].containsKey('MessageList') &&
            res['Status']['MessageList'] is List<dynamic> &&
            res['Status']['MessageList'].isNotEmpty) {
          Map<String, dynamic> firstMessage = res['Status']['MessageList'][0];
          String messageTitle = firstMessage['MessageTitle'];
          // String messageValue = firstMessage['MessageValue'];
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text(messageTitle),
            // content: Text(messageValue),
            actions: <Widget>[
              // MaterialButton(
              //   child: const Text("OK"),
              //   onPressed: () async {
              //     Navigator.pop(context);
              //     Geolocator.openLocationSettings();
              //   },
              // ),
              MaterialButton(
                child: const Text("CANCEL"),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text("Error"),
            content: const Text("Invalid response format"),
            actions: <Widget>[
              MaterialButton(
                child: const Text("OK"),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      },
    );
  }

}