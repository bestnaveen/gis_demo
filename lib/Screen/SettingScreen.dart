import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Screen'),
      ),
      body: Padding(
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
            TextField(
              controller: Provider.of<SettingScreenProvider>(context).isChainageBasisController,
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
          ],
        ),
      ),
    );
  }
}

