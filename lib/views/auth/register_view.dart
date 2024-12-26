import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:communityapp/controllers/auth_controller.dart';
import 'package:communityapp/services/auth_service.dart';
import 'package:communityapp/utils/logging.dart';
import 'package:communityapp/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  final dynamic username;

  const RegisterView({super.key, required this.username});

  @override
  State<RegisterView> createState() => _StateRegisterView();
}

class _StateRegisterView extends State<RegisterView> {
  final controller = Get.put(AuthController());
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _linkedIncontroller = TextEditingController();
  final TextEditingController _githubcontroller = TextEditingController();
  final log = Logging.log;
  bool available = true;
  bool hidepassword = true;

  File? _imageFile;
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      log.d("Image picked");
      _imageFile = File(pickedFile.path);
      if (_imageFile != null) {
        var cloudinary = Cloudinary.fromStringUrl(
            'cloudinary://239118281366527:${dotenv.env['CloudinaryApi']}@daj7vxuyb');
        final response = await cloudinary.uploader().upload(_imageFile);

        if (response != null &&
            response.data != null &&
            response.data!.secureUrl != null) {
          controller.imageUrl.value = response.data!.secureUrl!;
        }
      }
    }
  }

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
                "assets/images/profile.jpg",
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
                height: 30,
              ),
              const Text(
                "Lets setup your profile",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 80,
              ),
              Obx(
                () => GestureDetector(
                  onTap: () async {
                    _pickImage(ImageSource.gallery);
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: controller.imageUrl.value.isEmpty
                          ? null
                          : DecorationImage(
                              image: NetworkImage(controller.imageUrl.value),
                              fit: BoxFit.cover),
                      color: Colors.grey[300],
                    ),
                    child: controller.imageUrl.value.isEmpty
                        ? const Icon(
                            Icons.camera_alt,
                            size: 50,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
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
                    TextField(
                      controller: _namecontroller,
                      decoration: const InputDecoration(
                          hintText: 'Full Name',
                          icon: Icon(Icons.perm_identity,
                              color: Color.fromARGB(255, 65, 189, 115))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _linkedIncontroller,
                      decoration: const InputDecoration(
                          hintText: 'linkedIn id',
                          icon: Icon(FontAwesomeIcons.linkedin,
                              color: Color.fromARGB(255, 65, 189, 115))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _githubcontroller,
                      decoration: const InputDecoration(
                          hintText: 'Github Id',
                          icon: Icon(FontAwesomeIcons.github,
                              color: Color.fromARGB(255, 65, 189, 115))),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_githubcontroller.text.isNotEmpty &&
                            _linkedIncontroller.text.isNotEmpty &&
                            _githubcontroller.text.isNotEmpty &&
                            _namecontroller.text.isNotEmpty) {
                          AuthService.updateInfo(
                              widget.username,
                              _githubcontroller.text,
                              controller.imageUrl.value.isEmpty
                                  ? "https://res.cloudinary.com/daj7vxuyb/image/upload/v1731866387/samples/balloons.jpg"
                                  : controller.imageUrl.value,
                              _linkedIncontroller.text,
                              _namecontroller.text);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(
                                255, 65, 189, 115)), // Set the background color
                      ),
                      child: const Text(
                        'Lets Explore', // Change the text to "Sign In"
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                          fontWeight: FontWeight.bold, // Make the font bold
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
