import 'package:communityapp/controllers/auth_controller.dart';
import 'package:communityapp/services/auth_service.dart';
import 'package:communityapp/views/auth/signup_view.dart';
import 'package:communityapp/widgets/custom_widgets.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _StateSigninView();
}

class _StateSigninView extends State<LoginView> {
  final controller = Get.put(AuthController());
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(
                "assets/images/loginpage.jpg",
              ),
              fit: BoxFit.fitHeight,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // Black color with opacity
                BlendMode.darken, // Blend mode to darken the image
              ),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              const Text(
                "Welcome To",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/hackshashlogo.jpg"),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Hackslash",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                alignment: Alignment.center,
                height: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _emailcontroller,
                      decoration: const InputDecoration(
                          hintText: 'Email or username',
                          icon: Icon(Icons.email_outlined,
                              color: Color.fromARGB(255, 65, 189, 115))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => TextField(
                        controller: _passwordcontroller,
                        obscureText: controller.loginHidePass.value,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.toggleLoginPass();
                              },
                              icon: Icon(
                                  controller.loginHidePass.value
                                      ? Icons.remove_red_eye
                                      : Icons.password_outlined,
                                  color:
                                      const Color.fromARGB(255, 174, 179, 176)),
                            ),
                            icon: Icon(Icons.key,
                                color: Color.fromARGB(255, 65, 189, 115))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_emailcontroller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please input your email or username")));
                        } else if (_passwordcontroller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please input your password")));
                        } else {
                          final types.User usr = await AuthService.login(
                              _emailcontroller.text, _passwordcontroller.text);
                          if (usr.id != "NotAvailable") {
                            Get.off(() => MainView(
                                  username: usr.firstName.toString(),
                                ));
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(
                                255, 65, 189, 115)), // Set the background color
                      ),
                      child: const Text(
                        'Login', // Change the text to "Sign In"
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                          fontWeight: FontWeight.bold, // Make the font bold
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400], // Light gray color
                            ),
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(
                                  255, 65, 189, 115), // Custom color
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => const SignupView());
                              },
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400], // Light gray color
                        ),
                      ),
                      onPressed: () {
                        AuthService.forgotPassword();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
