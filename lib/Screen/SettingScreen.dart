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
    String initialIsChainageBasisValue = "true";
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
                  hintText: 'ProjectId',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: Provider.of<SettingScreenProvider>(context).projectCodeController,
                decoration: const InputDecoration(
                  hintText: 'ProjectCode',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: Provider.of<SettingScreenProvider>(context).featureIDController,
                decoration: const InputDecoration(
                  hintText: 'FeatureID',
                ),
              ),
              const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: initialIsChainageBasisValue,
            onChanged: (newValue) {
              textFieldProvider.isChainageBasisController.text = newValue!;
            },
            items: ["true", "false"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              hintText: 'IsChainageBasis',
            ),
          ),
              const SizedBox(height: 10),
              TextField(
                controller: Provider.of<SettingScreenProvider>(context).companyIdController,
                decoration: const InputDecoration(
                  hintText: 'CompanyId',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {},
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
    Provider.of<SettingScreenProvider>(context, listen: false).setIsChainageBasis(
      Provider.of<SettingScreenProvider>(context, listen: false).isChainageBasisController.text,
    );
    Provider.of<SettingScreenProvider>(context, listen: false).setCompanyId(
      Provider.of<SettingScreenProvider>(context, listen: false).companyIdController.text,
    );
  }
}

