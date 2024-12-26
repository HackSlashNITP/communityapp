import 'package:communityapp/firebase_options.dart';
import 'package:communityapp/models/message_model.dart';
import 'package:communityapp/models/user_model.dart';
import 'package:communityapp/views/auth/login_view.dart';
import 'package:communityapp/widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(HiveMessageAdapter());
  Hive.registerAdapter(HiveUserAdapter());
  runApp(const GetMaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController conr = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_auth.currentUser == null) {
        Get.off(() => const LoginView());
      } else {
        final box = Hive.openBox("userBox");
        box.then((box) {
          final user = box.get("user") as HiveUser;
          final username = user.firstname;
          log.d("User is $username");
          Get.off(() => MainView(username: username));
        });
      }
    });
  }

  void setText() {
    conr.text = "String";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Image.asset("assets/images/hackshashlogo.jpg"),
            const SizedBox(width: 20),
            const Text(
              "Hackslash",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
