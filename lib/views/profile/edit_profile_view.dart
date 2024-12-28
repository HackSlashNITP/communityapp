import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import '../../widgets/profile_widgets.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final EditProfileController editController = Get.put(EditProfileController(profileController));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (profileController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = profileController.userData.value;

          if (userData == null) {
            return Center(child: Text('No data available'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              bool isLandscape = constraints.maxWidth > constraints.maxHeight;
              if (!isLandscape) {

                //Layout design for portrait mode

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.20,
                                backgroundImage: NetworkImage(userData.avatarlink),
                                onBackgroundImageError: (_, __) => Icon(
                                  Icons.person,
                                  size: 60,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Profile Fields
                      EditProfileTextField(
                        controller: editController.nameController,
                        labelText: 'Name',
                        hintText: 'Enter new name',
                      ),
                      SizedBox(height: 20),
                      EditProfileTextField(
                        controller: editController.linkedinController,
                        labelText: 'LinkedIn',
                        hintText: 'Enter new LinkedIn ID',
                      ),
                      SizedBox(height: 20),
                      EditProfileTextField(
                        controller: editController.githubController,
                        labelText: 'Github',
                        hintText: 'Enter new Github profile',
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        style: ButtonStyle(
                          maximumSize: WidgetStateProperty.resolveWith(
                                (states) => Size(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.5),
                          ),
                          minimumSize: WidgetStateProperty.resolveWith(
                                (states) => Size(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.05),
                          ),
                          backgroundColor: WidgetStateProperty.all(Colors.green),
                        ),
                        onPressed: () => editController.saveChanges(),
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              } else {

                //Layout Design for Landscape

                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.13,
                        backgroundImage: NetworkImage(userData.avatarlink),
                        onBackgroundImageError: (_, __) => Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.width * 0.13,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EditProfileTextField(
                            controller: editController.nameController,
                            labelText: 'Name',
                            hintText: 'Enter new name',
                          ),
                          SizedBox(height: 10),
                          EditProfileTextField(
                            controller: editController.linkedinController,
                            labelText: 'LinkedIn',
                            hintText: 'Enter new LinkedIn ID',
                          ),
                          SizedBox(height: 10),
                          EditProfileTextField(
                            controller: editController.githubController,
                            labelText: 'Github',
                            hintText: 'Enter new Github profile',
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                              maximumSize: WidgetStateProperty.resolveWith(
                                    (states) => Size(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.2),
                              ),
                              minimumSize: WidgetStateProperty.resolveWith(
                                    (states) => Size(MediaQuery.of(context).size.width * 0.2, MediaQuery.of(context).size.height * 0.1),
                              ),
                              backgroundColor: WidgetStateProperty.all(Colors.green),
                            ),
                            onPressed: () => editController.saveChanges(),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }),
      ),
    );
  }
}