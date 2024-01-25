import 'package:flutter/cupertino.dart';

class SettingScreenProvider with ChangeNotifier {

  final TextEditingController _projectIdController = TextEditingController();
  TextEditingController get projectIdController => _projectIdController;

  final TextEditingController _qrValueController = TextEditingController();
  TextEditingController get qrValueController => _qrValueController;

  final TextEditingController _assetIdController = TextEditingController();
  TextEditingController get assetIdController => _assetIdController;

  final TextEditingController _projectCodeController = TextEditingController();
  TextEditingController get projectCodeController => _projectCodeController;

  final TextEditingController _featureIDController = TextEditingController();
  TextEditingController get featureIDController => _featureIDController;

  final TextEditingController _isChangeBasisController = TextEditingController();
  TextEditingController get isChangeBasisController => _isChangeBasisController;

  final TextEditingController _companyIdController = TextEditingController();
  TextEditingController get companyIdController => _companyIdController;

  final TextEditingController _remarksController = TextEditingController();
  TextEditingController get remarksController => _remarksController;

  final TextEditingController _assetTypeController = TextEditingController();
  TextEditingController get assetTypeController => _assetTypeController;

  final TextEditingController _locationController = TextEditingController();
  TextEditingController get locationController => _locationController;

  final TextEditingController _quantityController = TextEditingController();
  TextEditingController get quantityController => _quantityController;


  List<String> _qrCodes = [];
  List<String> get qrCodes => _qrCodes;


  void setProjectId(String value) {
    _projectIdController.text = value;
    notifyListeners();
  }

  void setProjectCode(String value) {
    _projectCodeController.text = value;
    notifyListeners();
  }

  void setFeatureID(String value) {
    _featureIDController.text = value;
    notifyListeners();
  }

  void setIsChangeBasis(String value) {
    _isChangeBasisController.text = value;
    notifyListeners();
  }

  void setCompanyId(String value) {
    _companyIdController.text = value;
    notifyListeners();
  }

  void setQuantity(String value) {
    _quantityController.text = value;
    notifyListeners();
  }

  void setLocation(String value) {
    _locationController.text = value;
    notifyListeners();
  }

  void setRemarkValue(String value) {
    _remarksController.text = value;
    notifyListeners();
  }

  void setAssetTypeValue(String value) {
    _assetTypeController.text = value;
    notifyListeners();
  }

  void resetAll(){
    _assetIdController.clear();
    _remarksController.clear();
    _quantityController.clear();
    _companyIdController.clear();
    _isChangeBasisController.clear();
    _featureIDController.clear();
    _projectCodeController.clear();
    _projectIdController.clear();
  }
}
