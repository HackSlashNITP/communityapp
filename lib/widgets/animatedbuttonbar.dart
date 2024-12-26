import 'package:communityapp/controllers/chatview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedButtonBar extends StatelessWidget {
  final String username;
  final ChatviewController controller;

  AnimatedButtonBar({super.key, required this.username})
      : controller = Get.put(ChatviewController(username: username));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green),
      ),
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            // Background container that moves based on the selected button
            Positioned(
              left: controller.isGroup.value ? 10 : 180,
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 51, 69),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      controller.isGroup.value = true;
                    },
                    child: Text(
                      'Groups',
                      style: TextStyle(
                        color: controller.isGroup.value
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      controller.isGroup.value = false;
                    },
                    child: Text(
                      'Meetings',
                      style: TextStyle(
                        color: !controller.isGroup.value
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
