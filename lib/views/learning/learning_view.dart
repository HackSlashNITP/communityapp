import '../../res/colors.dart';
import '../../widgets/learning_card.dart';
import 'package:flutter/material.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = screenWidth * 0.0025;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Row(
          children: [
            SizedBox(width: screenWidth * 0.15),
            SizedBox(
              height: 23,
              width: 23,
              child: Image.asset('assets/images/Booo.png'),
            ),
            SizedBox(width: screenWidth * 0.03),
            Text('Learning', style: TextStyle(fontSize: 24 * textScaleFactor)),
          ],
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.8, 10, 10, 5),
              child: Image.asset('assets/images/imag.png'),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.1, 20, 0, 0),
              child: Text(
                'Hello Rahul,',
                style: TextStyle(
                  fontSize: 22 * textScaleFactor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.07, 0, 0, 0),
              child: Text(
                'Continue\nLearning!',
                style: TextStyle(
                  fontSize: 43 * textScaleFactor,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.08),
                  child: Text(
                    'Your Lessons',
                    style: TextStyle(
                      fontSize: 22 * textScaleFactor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.25),
                InkWell(
                  child: Image.asset('assets/images/Four.png'),
                  onTap: () {},
                ),
                InkWell(
                  child: Image.asset('assets/images/red.png'),
                  onTap: () {},
                ),
              ],
            ),
            Container(
              height: 2.5,
              color: ColorPalette.brightEmeraldGreen,
            ),
            Row(
              children: [
                LearningCard(imagePath: "assets/images/420.png", cardName: "Personalized\nLearning", onTap: (){}),
                LearningCard(imagePath: "assets/images/jiji.png", cardName: "Playlist", onTap: (){}),
              ],
            ),
            Row(
              children: [
                LearningCard(imagePath: "assets/images/popo.png", cardName: "Projects", onTap: (){}),
                LearningCard(imagePath: "assets/images/imag00.png", cardName: "Pdf Notes", onTap: (){}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
