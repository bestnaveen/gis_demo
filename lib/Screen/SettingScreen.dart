import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/SettingProvider.dart';
import '../main.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    SettingScreenProvider textFieldProvider = SettingScreenProvider();
    String initialIsChainageBasisValue = "false";
    String assetTypeProduct = "pipe";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: Provider.of<SettingScreenProvider>(context).projectIdController,
                decoration: const InputDecoration(
                  hintText: 'Assets',
                  labelText: 'ProjectId',
                  floatingLabelBehavior: FloatingLabelBehavior.always
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: Provider.of<SettingScreenProvider>(context).projectCodeController,
                decoration: const InputDecoration(
                  hintText: 'Yard',
                  labelText: 'ProjectCode',
                  floatingLabelBehavior: FloatingLabelBehavior.always
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: Provider.of<SettingScreenProvider>(context).featureIDController,
                decoration: const InputDecoration(
                  hintText: '0',
                    labelText: 'FeatureID',
                  floatingLabelBehavior: FloatingLabelBehavior.always
                ),
              ),
              const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: initialIsChainageBasisValue,
            onChanged: (newValue) {
              textFieldProvider.isChangeBasisController.text = newValue!;
            },
            items: ["true", "false"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              hintText: 'false',
              labelText: 'IsChainageBasis'
            ),
          ),
              const SizedBox(height: 10),
              TextField(
                controller: Provider.of<SettingScreenProvider>(context).companyIdController,
                decoration: const InputDecoration(
                  hintText: 'ADNOC',
                  labelText: 'CompanyId',
                  floatingLabelBehavior: FloatingLabelBehavior.always
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
               Navigator.pop(context);
                },
                child: const Text('SET DATA'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setData(BuildContext context) {
    Provider.of<SettingScreenProvider>(context, listen: false).setProjectId(
      Provider.of<SettingScreenProvider>(context, listen: false).projectIdController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setProjectCode(
      Provider.of<SettingScreenProvider>(context, listen: false).projectCodeController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setFeatureID(
      Provider.of<SettingScreenProvider>(context, listen: false).featureIDController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setIsChangeBasis(
      Provider.of<SettingScreenProvider>(context, listen: false).isChangeBasisController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setCompanyId(
      Provider.of<SettingScreenProvider>(context, listen: false).companyIdController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setQuantity(
      Provider.of<SettingScreenProvider>(context, listen: false).quantityController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setRemarkValue(
      Provider.of<SettingScreenProvider>(context, listen: false).remarksController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setAssetTypeValue(
      Provider.of<SettingScreenProvider>(context, listen: false).assetTypeController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setItemReceivedValue(
      Provider.of<SettingScreenProvider>(context, listen: false).itemReceivedController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setItemDefectValue(
      Provider.of<SettingScreenProvider>(context, listen: false).itemDefectController.text,
    );
  }
}

