import 'package:flutter/cupertino.dart';

class SettingScreenProvider with ChangeNotifier {
  TextEditingController assetIdController = TextEditingController();
  TextEditingController qrValueController = TextEditingController();
  TextEditingController projectIdController = TextEditingController();
  TextEditingController projectCodeController = TextEditingController();
  TextEditingController featureIDController = TextEditingController();
  TextEditingController isChainageBasisController = TextEditingController();
  TextEditingController companyIdController = TextEditingController();


  void setProjectId(String value) {
    projectIdController.text = value;
    notifyListeners();
  }

  void setProjectCode(String value) {
    projectCodeController.text = value;
    notifyListeners();
  }

  void setFeatureID(String value) {
    featureIDController.text = value;
    notifyListeners();
  }

  void setIsChainageBasis(String value) {
    isChainageBasisController.text = value;
    notifyListeners();
  }

  void setCompanyId(String value) {
    companyIdController.text = value;
    notifyListeners();
  }

}
