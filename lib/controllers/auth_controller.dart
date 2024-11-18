import 'package:communityapp/services/auth_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool loginHidePass = true.obs;
  void toggleLoginPass() {
    loginHidePass.value = !loginHidePass.value;
  }

  RxBool signupHidePass = true.obs;
  void toggleSignupPass() {
    signupHidePass.value = !signupHidePass.value;
  }

  RxBool unameAvailiblitiy = true.obs;
  void checkUsernameAvailibility(String username) async {
    List users = await AuthService.getUsersList();
    if (users.contains(username)) {
      unameAvailiblitiy.value = false;
    } else if (users.contains(username) == false) {
      unameAvailiblitiy.value = true;
    }
  }

  RxString imageUrl = "".obs as RxString;
}
