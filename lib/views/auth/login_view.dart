import 'package:communityapp/controllers/login_controller.dart';
import 'package:communityapp/views/auth/signup_view.dart';
import 'package:communityapp/views/components/auth_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _StateLoginView();
}

class _StateLoginView extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final component = AuthComponents();
  final controller = Get.put(LoginController());

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
        borderRadius: BorderRadius.circular(8),
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
        hintText: 'Email',
        prefixIcon: Icons.email_outlined,
        isPortrait: isPortrait,
      ),
      SizedBox(height: 24.h),
      component.buildPasswordField(
        isPortrait: isPortrait,
        toggleObscureText: controller.toggleObscureText,
        controller: _passwordController,
        obscureText: controller.obscureText,
      ),
      SizedBox(height: 24.h),
      component.buildbtn("Login", controller.isLoading,isPortrait, _handleLogin),
      SizedBox(height: 16.h),
      component.buildActionText("Don't have an account? ", 'Sign Up',
          () => Get.off(() => const SignupView()), isPortrait),
      SizedBox(height: 12.h),
      component.buildActionText(
          '', 'Forgot password?', controller.forgotPassword, isPortrait),
    ];
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please input your email")));
    } else if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please input your password")));
    } else {
      controller.login(_emailController.text, _passwordController.text);
    }
  }
}
