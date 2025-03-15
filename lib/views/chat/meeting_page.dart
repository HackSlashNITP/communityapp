

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:communityapp/views/chat/meeting_view.dart';
import 'package:communityapp/controllers/meeting_controller.dart';

class MeetingPage extends StatefulWidget {
  final String username;
  MeetingPage({required this.username});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final TextEditingController _channelController = TextEditingController();
  late VideoCallController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VideoCallController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "HackSlash Meeting Room",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildGlassContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Join a Meeting",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                            color: Color(0xff110E2B),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(),
                      SizedBox(height: 20),
                      _buildJoinButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF110E2B), Color(0xFF1C173C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }


  Widget _buildTextField() {
    return TextField(
      controller: _channelController,
      style: TextStyle(color: Color(0xff110E2B),),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        labelText: "Enter Meeting ID",
        labelStyle: TextStyle(color: Color(0xff110E2B), fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),  borderSide: BorderSide(color: Color(0xff110E2B), width: 2),),
        prefixIcon: Icon(Icons.meeting_room, color: Color(0xff110E2B),),
      ),
    );
  }


  Widget _buildJoinButton() {
    return GestureDetector(
      onTap: () {
        final meetingId = _channelController.text.trim();
        if (meetingId.isNotEmpty) {
          Get.to(() => VideoCallScreen(username: widget.username));
          controller.fetchTokenAndJoinChannel(meetingId);
        } else {
          Get.snackbar("Error", "Please enter a valid Meeting ID.",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff110E2B),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.purple.withOpacity(0.4), blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: Center(
          child: Text(
            "Join Meeting",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
