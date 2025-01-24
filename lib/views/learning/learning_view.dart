import 'package:communityapp/res/colors.dart';
import 'package:communityapp/views/learning/ai_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/learning_card.dart';

class LearningView extends StatelessWidget {
  LearningView({super.key, this.name, this.uid});

  final double height = Get.height;
  final double width = Get.width;

  final String? name;
  final String? uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/learning/leading_icon.png",
              height: 30,
            ),
            const Text(
              ' Hackslash',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        backgroundColor:
            const Color(0xFF223345), // Set your desired background color
        actions: [
          Switch(
            value: false, // This can be controlled with a state variable
            onChanged: (value) {
              // Handle toggle action
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF223345),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          height: height * 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${name ?? 'User'}',
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Let's Continue",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Learning!",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: width * 0.15,
                      backgroundImage:
                          const AssetImage("assets/learning/profile_img.png"),
                      backgroundColor: const Color(0xFFD9D9D9),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Lessons',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      "assets/learning/lesson_icon.png",
                      height: 30,
                    )
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(
                  thickness: 2,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () {
                      _buildSearchUI();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.brightEmeraldGreen,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      fixedSize: Size(
                        width * 0.5,
                        width * 0.12,
                      ),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Get.to(AiChatView(
                            uid: uid ?? "random_id_9855jh35iy5",
                            name: name ?? "User",
                          ));
                        },
                        child: Text(
                          "AI Search",
                          style:
                              TextStyle(color: Color(0xFF223345), fontSize: 16),
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(10),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 5.0 / 6.0,
                    children: learningCards.map((card) {
                      return LearningCard(
                        cardName: card["name"]!,
                        imagePath: card["imagePath"]!,
                        onTap: card[
                            "onTap"], // Assign the specific onTap function here
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> learningCards = [
    {
      "name": "Roadmap",
      "imagePath": "assets/learning/roadmap_icon.png",
      "onTap": () => print("Roadmap tapped"),
    },
    {
      "name": "Playlist",
      "imagePath": "assets/learning/playlist_icon.png",
      "onTap": () => print("Playlist tapped"),
    },
    {
      "name": "Projects",
      "imagePath": "assets/learning/projects_icon.png",
      "onTap": () => print("Projects tapped"),
    },
    {
      "name": "Pdf Notes",
      "imagePath": "assets/learning/pdf_icon.png",
      "onTap": () => print("Pdf Notes tapped"),
    },
  ];
  _buildSearchUI() {
    if (Get.isBottomSheetOpen!) return;
    return Get.bottomSheet(
        elevation: 4,
        backgroundColor: Color(0xFF223345),
        isDismissible: true,
        enableDrag: true,
        persistent: true,
        Column());
  }
}
