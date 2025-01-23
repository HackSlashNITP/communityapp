import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpDesk extends StatefulWidget {
  const HelpDesk({super.key});

  @override
  State<HelpDesk> createState() => _HelpDeskState();
}

class _HelpDeskState extends State<HelpDesk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffF1EFEF),
              Color(0xffFFFFFF),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        size: MediaQuery
                            .of(context)
                            .size
                            .height * 0.04,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Help Desk',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04,
              ),
              const Text(
                'Contact options',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
              ),
              _buildContactOption(
                context,
                label: 'Email Us',
                onPressed: () {
                  // Handle email action
                }, icon: Icon(Icons.email_outlined),
              ),
              _buildContactOption(
                context,
                label: 'Call Us',
                onPressed: () {
                  // Handle call action
                }, icon: Icon(Icons.call),
              ),
              _buildContactOption(
                context,
                label: 'Chat with Us',
                onPressed: () {
                  // Handle chat action
                }, icon: Icon(Icons.chat),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildContactOption(BuildContext context,
      {required Icon icon,
        required String label,
        required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(
          const Color(0xffE6E7E6).withOpacity(0.4),
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
            height: MediaQuery
                .of(context)
                .size
                .height * 0.035,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.06,
            child: icon,
          ),
          SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.04,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
