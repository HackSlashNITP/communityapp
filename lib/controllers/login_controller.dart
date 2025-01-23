import 'package:communityapp/services/auth_service.dart';
import 'package:communityapp/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool obscureText = true.obs;
  RxBool isLoading = false.obs;

  void login(String email, String password) async {
    try {
      isLoading.value = true;
      await AuthService.login(email, password); // Await the async call
    } catch (e) {
      Logging.log.e(e);
      Get.snackbar(
        'Error',
        e.toString(),
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void forgotPassword() => AuthService.forgotPassword();
}
