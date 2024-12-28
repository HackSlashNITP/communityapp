import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../auth/login_view.dart';

class AccountSettings extends StatelessWidget {

  final ProfileController controller = Get.find<ProfileController>();
  AccountSettings({super.key});

  // Function to handle account deletion
  void _handleDeleteAccount() {
    Get.defaultDialog(
      title: 'Delete Account?',
      middleText: 'Are you sure you want to delete your account? This action cannot be undone.',
      confirm: TextButton(
        onPressed: () async {
          // Call to delete account
          await controller.deleteAccount();
          Get.offAll(() => LoginView()); // Navigate to login page after deletion
        },
        child: const Text('Yes'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('No'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Reusable Setting Row Widget
    Widget buildSettingRow({
      required String title,
      VoidCallback? onPressed,
      required Icon icon,
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: screenHeight * .035,
                width: screenWidth * .06,
                child: icon,
              ),
              SizedBox(width: screenWidth * .03),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 19,
            ),
          ),
        ],
      );
    }

    // Reusable Button Widget
    Widget buildThemedButton({
      required Icon icon,
      required String title,
      required VoidCallback onPressed,
    }) {
      return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.secondary.withOpacity(0.4),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: screenHeight * .035,
              width: screenWidth * .06,
              child: icon,
            ),
            SizedBox(width: screenWidth * .03),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffF1EFEF), Color(0xffFFFFFF)],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.keyboard_arrow_left, size: 28),
                  ),
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 32), // Placeholder for symmetry
                ],
              ),
              SizedBox(height: screenHeight * .04),

              // Placeholder Text for User Info
              Text(
                'User Info', // Just a placeholder for now
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * .03),

              // Settings Rows
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildSettingRow(
                        title: 'Your Info',
                        onPressed: () {}, icon: Icon(Icons.person), // Placeholder for Your Info
                      ),
                      buildSettingRow(
                        title: 'Notifications',
                        onPressed: () {}, icon: Icon(Icons.notifications), // Placeholder for Notifications
                      ),
                      buildSettingRow(
                        title: 'Password',
                        onPressed: () {}, icon: Icon(Icons.lock), // Placeholder for Password
                      ),
                      buildSettingRow(
                        title: 'Theme',
                        onPressed: () {
                          Get.bottomSheet(
                            Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.dark_mode),
                                    title: const Text('Dark Mode'),
                                    onTap: () => Get.changeTheme(ThemeData.dark()),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.light_mode),
                                    title: const Text('Light Mode'),
                                    onTap: () => Get.changeTheme(ThemeData.light()),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, icon: Icon(Icons.nightlight),
                      ),
                      SizedBox(height: screenHeight * .04),
                      buildThemedButton(
                        title: 'Terms & Conditions',
                        onPressed: () {}, icon: Icon(Icons.edit_note, color: Colors.black), // Placeholder for Terms & Conditions
                      ),
                      buildThemedButton(
                        title: 'Feedback',
                        onPressed: () {}, icon: Icon(Icons.feedback, color: Colors.black), // Placeholder for Feedback
                      ),
                      buildThemedButton(
                        title: 'Delete Account',
                        onPressed: _handleDeleteAccount, icon: Icon(Icons.delete, color: Colors.black,), // Call to handle delete account
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}