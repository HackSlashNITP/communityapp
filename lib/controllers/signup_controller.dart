import 'package:communityapp/views/auth/register_view.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../utils/logging.dart';

class SignupController extends GetxController {
  RxBool obscureText = true.obs;
  RxBool isLoading = false.obs;

  void signup(String email, String password) async {
    try {
      isLoading.value = true;
      String uid = await AuthService.signup(email, password);
      Get.off(RegisterView(uid: uid));
    } catch (e) {
      Logging.log.e(e);
      Get.snackbar("Error while creating account", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  void forgotPassword() => AuthService.forgotPassword();
}
