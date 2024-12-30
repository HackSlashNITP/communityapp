import 'package:flutter/material.dart';

//Reusable Profile Info and Utilities Widget

class ProfileInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final Widget leading;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.leading,
    this.backgroundColor = const Color(0xffE6FCEF),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    double tileHeight = isLandscape
        ? MediaQuery.of(context).size.height * 0.1 // Adjust height for landscape
        : MediaQuery.of(context).size.height * 0.058; // Adjust height for portrait

    double paddingHorizontal = isLandscape
        ? MediaQuery.of(context).size.width * 0.04
        : MediaQuery.of(context).size.width * 0.02;

    double leadingSize = isLandscape
        ? MediaQuery.of(context).size.height * 0.08
        : MediaQuery.of(context).size.height * 0.05;

    double fontSize = isLandscape ? 16 : 14;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: tileHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: leadingSize,
                    width: leadingSize,
                    child: leading,
                  ),
                  SizedBox(
                    width: isLandscape
                        ? MediaQuery.of(context).size.width * 0.02
                        : MediaQuery.of(context).size.width * 0.016,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'JoseLight',
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Reusable Edit Profile TextField Widget

class EditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;


  const EditProfileTextField({super.key, 
    required this.controller,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
          fontWeight: FontWeight.bold
      ),
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}