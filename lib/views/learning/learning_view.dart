import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {

  double height=Get.height;
  double width=Get.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu,color: Colors.white,),
              onPressed: () {
                // Handle menu action
              },
            ),
            SizedBox(width: 8), // Space between icon and text
            Text('Hackslash',style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
          ],
        ),
        backgroundColor: Color(0xFF223345), // Set your desired background color
        actions: [
          Switch(
            value: false, // This can be controlled with a state variable
            onChanged: (value) {
              // Handle toggle action
            },),],),
      body:

      Container(
        color: Color(0xFF223345),
        child:
        Container(
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),


          ),
          height: height*1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Hello Tanay',
                          style: TextStyle(
                            fontSize: 50,
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
                          " Learning!",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    const CircleAvatar(
                      radius: 50,
                      //backgroundImage: , // Replace with your image
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const Text(
                  'Your Lessons',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Divider(
                  thickness: 2,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'AI Search ?',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildGridItem('Road Map', Icons.map, Colors.green),
                      _buildGridItem('Playlist', Icons.playlist_play, Colors.blue),
                      _buildGridItem('Projects', Icons.lightbulb, Colors.orange),
                      _buildGridItem('PDF Notes', Icons.picture_as_pdf, Colors.red),
                    ],


                  ),
                ),

              ],

            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
Widget _buildGridItem(String title, IconData icon, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 48,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    ),
  );
}


