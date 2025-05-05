import 'package:get/get.dart';

class TextFieldController extends GetxController {
  Rx<String> address = ''.obs;
  Rx<String> bio = ''.obs;
  Rx<String> age = ''.obs;

  void onAddressChange(String? value) {
    if (value != null) {
      address.value = value;
    }
  }

  void onBioChange(String? value) {
    if (value != null) {
      bio.value = value;
    }
  }

  void onAgeChange(String? value) {
    if (value != null) {
      age.value = value;
    }
  }
}
