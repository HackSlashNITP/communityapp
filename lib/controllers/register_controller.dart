import 'package:communityapp/services/auth_service.dart';
import 'package:communityapp/widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxString imageUrl = "".obs;
  RxBool isLoading = false.obs;

  void handleResistration({
    required String fullname,
    required String github,
    required String linkedin,
    required String avatar,
  }) {
    try {
      final user = FirebaseAuth.instance;
      if (user.currentUser != null) {
        user.currentUser!.updateProfile(displayName: fullname);
        AuthService.updateInfo(
            uid: user.currentUser!.uid,
            github: github,
            avatar: avatar,
            linkedin: linkedin,
            name: fullname);
        Get.off(MainView(userid: user.currentUser!.uid));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
