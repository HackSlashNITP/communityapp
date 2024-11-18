import 'package:communityapp/controllers/auth_controller.dart';
import 'package:communityapp/services/auth_service.dart';
import 'package:communityapp/views/auth/login_view.dart';
import 'package:communityapp/views/auth/register_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _StateSignupView();
}

class _StateSignupView extends State<SignupView> {
  final controller = Get.put(AuthController());
  final TextEditingController _usernamecontroller = TextEditingController();
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
                height: 325,
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
                    Obx(
                      () => Column(
                        children: [
                          TextField(
                        controller: _usernamecontroller,
                        decoration: const InputDecoration(
                            hintText: 'Username',
                            icon: Icon(Icons.person_2_outlined,
                                color: Color.fromARGB(255, 65, 189, 115))),
                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            controller.checkUsernameAvailibility(value);
                          }
                        },
                      ),
              
                     controller.unameAvailiblitiy.value
                          ? Container() // Display nothing if available
                          : Text(
                              "${_usernamecontroller.text} is not available",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.red),
                              textAlign: TextAlign.right,
                            ),
                        ],
                      )
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _emailcontroller,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          icon: Icon(Icons.email_outlined,
                              color: Color.fromARGB(255, 65, 189, 115))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  Obx(()=>   TextField(
                        controller: _passwordcontroller,
                        obscureText: controller.signupHidePass.value,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.toggleSignupPass();
                              },
                              icon: Icon(
                                  controller.signupHidePass.value
                                      ? Icons.remove_red_eye
                                      : Icons.password_outlined,
                                  color:
                                      const Color.fromARGB(255, 174, 179, 176)),
                            ),
                            icon: Icon(Icons.key,
                                color: Color.fromARGB(255, 65, 189, 115))),
                      ),),
                    
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        bool isValid = await AuthService.validateInputs(
                            _usernamecontroller.text,
                            _emailcontroller.text,
                            _passwordcontroller.text,
                            context);
                        if (isValid) {
                          bool success = await AuthService.signIn(
                            _usernamecontroller.text,
                            _emailcontroller.text,
                            _passwordcontroller.text,
                          );
                          if (success) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterView(
                                        username: _usernamecontroller.text)));
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(
                                255, 65, 189, 115)), // Set the background color
                      ),
                      child: const Text(
                        'Sign In', // Change the text to "Sign In"
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
                            text: 'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400], // Light gray color
                            ),
                          ),
                          TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(
                                    255, 65, 189, 115), // Custom color
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginView()));
                                }
                              // Action when "Login" is tapped

                              ),
                        ],
                      ),
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
