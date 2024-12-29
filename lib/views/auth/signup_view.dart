import 'package:communityapp/controllers/signup_controller.dart';
import 'package:communityapp/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../components/auth_components.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _StateSignupView();
}

class _StateSignupView extends State<SignupView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cnfpasswordController = TextEditingController();
  final controller = Get.put(SignupController());
  final component = AuthComponents();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isPortrait = orientation == Orientation.portrait;
          return _buildLayout(isPortrait);
        },
      ),
    );
  }

  Widget _buildLayout(bool isPortrait) {
    return Container(
      alignment: Alignment.center,
      height: isPortrait ? 955.h : 430.h,
      width: isPortrait ? 430.w : 955.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/loginpage.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: isPortrait
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...component.buildLogo(isPortrait),
                  SizedBox(height: 40.h),
                  _buildContainer(isPortrait)
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: component.buildLogo(isPortrait)),
                    SizedBox(width: 20.w),
                    _buildContainer(isPortrait)
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildContainer(bool isPortrait) {
    return Container(
      padding: EdgeInsets.all(32.r),
      constraints: BoxConstraints(maxWidth: isPortrait ? 360 : double.infinity),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildForm(isPortrait),
      ),
    );
  }

  List<Widget> _buildForm(bool isPortrait) {
    return [
      component.buildTextField(
        controller: _emailController,
        hintText: 'Email ',
        prefixIcon: Icons.email_outlined,
        isPortrait: isPortrait,
      ),
      SizedBox(height: 24.h),
      component.buildPasswordField(
          controller: _passwordController,
          isPortrait: isPortrait,
          obscureText: controller.obscureText,
          toggleObscureText: controller.toggleObscureText),
      SizedBox(height: 24.h),
      component.buildPasswordField(
          controller: _cnfpasswordController,
          isPortrait: isPortrait,
          obscureText: controller.obscureText,
          toggleObscureText: controller.toggleObscureText),
      SizedBox(height: 24.h),
      component.buildbtn(
          "Sign Up", controller.isLoading, isPortrait, _handleSignup),
      SizedBox(height: 16.h),
      component.buildActionText("Already have account? ", 'Login',
          () => Get.off(() => const LoginView()), isPortrait),
    ];
  }

  void _handleSignup() {
    if (_emailController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please input your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade800,
        colorText: Colors.white,
      );
    } else if (_passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please input your password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade800,
        colorText: Colors.white,
      );
    } else if (_passwordController.text.toString() !=
        _cnfpasswordController.text.toString()) {
      Get.snackbar(
        "Error",
        "Password must be equal to confirm passowrd",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade800,
        colorText: Colors.white,
      );
    } else {
      controller.signup(_emailController.text, _passwordController.text);
    }
  }
}
