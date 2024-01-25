import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
  TextEditingController qrValueController = TextEditingController(text: '');
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController altitudeController = TextEditingController();
  String? latitude = '', longitude = '', altitude = '';

  String assetTypeProduct = "pipe";

  SettingScreenProvider textFieldProvider = SettingScreenProvider();
  @override
  void initState() {
   textFieldProvider = context.read<SettingScreenProvider>();
    super.initState();
  }

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
                onTap: (){
                  _startScanner();
                },
                readOnly: true,
                controller: textFieldProvider.qrValueController,
                decoration:  InputDecoration(
                  labelText: "Tag No.",
                  hintText: 'Scanned QR value',
                  suffixIcon: IconButton(onPressed: (){
                    _startScanner();
                  }, icon: const Icon(Icons.qr_code)),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: assetTypeProduct,
                onChanged: (newValue) {
                  textFieldProvider.assetTypeController.text = newValue!;
                  // assetTypeProduct = newValue!;
                },
                items: ["pipe", "tee", "flange", "valves", "reducer", "elbow"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                    labelText: 'Asset Type'
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textFieldProvider.quantityController,
                decoration: const InputDecoration(
                    labelText: 'Quantity'
                ),
                onChanged: (value){
                  textFieldProvider.setQuantity(value);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textFieldProvider.locationController,
                decoration: const InputDecoration(
                    labelText: 'Location'
                ),
                onChanged: (value){
                  textFieldProvider.setLocation(value);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textFieldProvider.remarksController,
                decoration: const InputDecoration(
                    labelText: 'Remarks'
                ),
                onChanged: (value){
                  textFieldProvider.setRemarkValue(value);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: assetIdController,
                decoration: const InputDecoration(
                  label: Text("AssetId"),
                  hintText: 'Asset Id',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: longitudeController,
                decoration:  InputDecoration(
                  hintText: 'Geo Location',
                  label: const Text("Longitude"),
                  suffixIcon: IconButton(onPressed: (){
                    locationPermission();
                  }, icon: const Icon(Icons.place_outlined)),
                ),
              ),
              if(longitudeController.text!=''&& latitudeController.text!=''&& altitudeController.text!='')TextField(
                controller: latitudeController,
                decoration:  InputDecoration(
                  hintText: 'Scanned QR value',
                  label: const Text("Latitude"),
                  suffixIcon: IconButton(onPressed: (){

                  }, icon: const Icon(Icons.place_outlined)),
                ),
              ),
              if(longitudeController.text!=''&& latitudeController.text!=''&& altitudeController.text!='')
                TextField(
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

  resetAll({SettingScreenProvider? textFieldProvider}) {
    assetIdController.clear();
    qrValueController.clear();
    latitude = '';
    longitude = '';
    altitude = '';
    textFieldProvider?.resetAll();
    setState(() {});
  }


  submit() async {
    var payload = {
      "ProjectId": "Assets",
      "ProjectCode": "Yard",
      "FeatureID": "0",
      "IsChainageBasis": false,
      "CompanyId": "ADNOC",
      "data": [
        {
          "attributes": {
            "location": textFieldProvider.locationController.value.text.toString(),
            "assetId": assetIdController.value.text.toString(),
            "qrCode": qrValueController.value.text.toString(),
            "quantity": textFieldProvider.quantityController.value.text.toString(),
            "assetType": textFieldProvider.assetTypeController.value.text.toString(),
            "remarks": textFieldProvider.remarksController.value.text.toString(),
          },
          "coordinates": [
            {"x": longitudeController.text, "y": latitudeController.text, "z": altitudeController.text}
          ]
        }
      ]
    };


    String payloadString = jsonEncode(payload);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payload'),
          content: SingleChildScrollView(
            child: Text(payloadString),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text("Submit"),
              onPressed: () async {
                Navigator.pop(context); // Close the payload dialog
                await submitRequest(payload);
              },
            ),
            MaterialButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context); // Close the payload dialog
              },
            ),
          ],
        );
      },
    );
  }


  submitRequest(dynamic payload) async {
    String url = 'https://entgissync.pipetrakit.com/api/GISSync/SyncObject';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(payload),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Request successful");
        print(response.body);
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
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: Text(messageTitle),
            actions: <Widget>[
              MaterialButton(
                child: const Text("Cancel"),
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