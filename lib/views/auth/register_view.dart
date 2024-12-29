import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:communityapp/controllers/register_controller.dart';
import 'package:communityapp/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../components/auth_components.dart';

class RegisterView extends StatefulWidget {
  final String uid;
  const RegisterView( {super.key, required this.uid});

  @override
  State<RegisterView> createState() => _StateRegisterView();
}

class _StateRegisterView extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _linkedInController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();
  final controller = Get.put(RegisterController());
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
          image: const AssetImage("assets/images/profile.jpg"),
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
                  _buildImage(isPortrait),
                  SizedBox(height: 40.h),
                  _buildContainer(isPortrait)
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImage(isPortrait),
                    SizedBox(width: 20.w),
                    _buildContainer(isPortrait)
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      Logging.log.d("Image picked");
      final imageFile = File(pickedFile.path);
      var cloudinary = Cloudinary.fromStringUrl(
          'cloudinary://239118281366527:${dotenv.env['CloudinaryApi']}@daj7vxuyb');
      final response = await cloudinary.uploader().upload(imageFile);

      if (response != null &&
          response.data != null &&
          response.data!.secureUrl != null) {
        controller.imageUrl.value = response.data!.secureUrl!;
      }
    }
  }

  Widget _buildImage(bool isPortrait) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          _pickImage(ImageSource.gallery);
        },
        child: Container(
          width: 160.w,
          height: 160.w,
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
              ?  Icon(
                  Icons.camera_alt,
                  size: 50.r,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildContainer(bool isPortrait) {
    return Container(
      padding: EdgeInsets.all(32.r),
      constraints: BoxConstraints(maxWidth: isPortrait ? 500 : double.infinity),
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
        controller: _nameController,
        hintText: 'Email',
        prefixIcon: Icons.email_outlined,
        isPortrait: isPortrait,
      ),
      SizedBox(height: 24.h),
      component.buildTextField(
          controller: _linkedInController,
          hintText: "Linked In",
          prefixIcon: FontAwesomeIcons.linkedinIn,
          isPortrait: isPortrait),
      SizedBox(height: 24.h),
      component.buildTextField(
          controller: _githubController,
          hintText: "github",
          prefixIcon: FontAwesomeIcons.github,
          isPortrait: isPortrait),
      SizedBox(height: 24.h),
      component.buildbtn("Lets Explore", controller.isLoading, isPortrait,
          _handleRegistration),
    ];
  }

  void _handleRegistration() {
    if (_nameController.text.isEmpty ||
        _githubController.text.isEmpty ||
        _linkedInController.text.isEmpty) {
      Get.snackbar("Error", "Kindly Fill all the fields");
    } else {
      controller.handleResistration(fullname: _nameController.text, github: _githubController.text, linkedin: _linkedInController.text, avatar: controller.imageUrl.value.isEmpty ? "https://res.cloudinary.com/daj7vxuyb/image/upload/v1731866387/samples/balloons.jpg": controller.imageUrl.value);
    }
  }
}
