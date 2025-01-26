import 'package:communityapp/controllers/chatview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.green),
      ),
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            // Background container that moves based on the selected button
            Positioned(
              left: controller.isGroup.value ? 10.w : 180.w,
              child: Container(
                height: 40.h,
                width: 150.w,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 51, 69),
                  borderRadius: BorderRadius.circular(5.r),
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
