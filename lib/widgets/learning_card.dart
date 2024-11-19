import '../res/colors.dart';
import 'package:flutter/material.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({
    super.key,
    required this.imagePath,
    required this.cardName,
    required this.onTap});

  final String imagePath;
  final String cardName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05 , vertical: screenWidth * 0.03),
      child: Container(
        decoration: BoxDecoration(
            color: ColorPalette.lightAquaGreen,
            borderRadius: BorderRadius.circular(20)),
        height: screenWidth * 0.5,
        width: screenWidth * 0.4,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath),
              Text(
                cardName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
