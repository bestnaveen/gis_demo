import 'package:flutter/cupertino.dart';

class SettingScreenProvider with ChangeNotifier {
  TextEditingController assetIdController = TextEditingController();
  TextEditingController qrValueController = TextEditingController();
  TextEditingController projectIdController = TextEditingController();
  TextEditingController projectCodeController = TextEditingController();
  TextEditingController featureIDController = TextEditingController();
  TextEditingController isChainageBasisController = TextEditingController();
  TextEditingController companyIdController = TextEditingController();
}
