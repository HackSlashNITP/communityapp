import 'package:flutter/material.dart';

class GroupBox extends StatelessWidget {
  final String channelName;
  final String avatar;
  final String? lastMessage;
  final String? sender;
  final int unreads;

  const GroupBox(
      {super.key,
      required this.avatar,
      required this.channelName,
      this.lastMessage,
      required this.unreads,
      this.sender});
  // required this.time});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(5, 4),
                blurRadius: 4,
              )
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 246, 243, 243)
                  .withOpacity(0.59), //rgba(242, 239, 239, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            height: 180,
            width: 350,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(avatar),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 200,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          channelName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black)),
                  height: 80,
                  child: Text(
                   "${sender ?? "Anonymous User"} : ${lastMessage ??
                        "Kindly adhere to the community guidelines"}",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color.fromRGBO(114, 114, 114, 1),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: 20,
          child: Image.asset(
            "assets/images/sendmail.png",
            height: 35,
            width: 35,
          ),
        ),
        Positioned(
          top: 5,
          right: 15,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: Color.fromARGB(255, 231, 18, 18),
            child: Text(
              unreads.toString(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Positioned(
          right: 25,
          bottom: 30,
          child: Text("12:18"),
        )
      ],
    );
  }
}
