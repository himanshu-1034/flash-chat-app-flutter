import 'package:flutter/material.dart';
import 'package:flash_chatting_app/screens/chat_screen.dart';
import 'package:flash_chatting_app/screens/login_screen.dart';
import 'package:flash_chatting_app/screens/registration_screen.dart';
import 'package:flash_chatting_app/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      routes: {
        WelcomeScreen.id: (context)=>WelcomeScreen(),
       LoginScreen.id: (context)=>LoginScreen(),
        RegistrationScreen.id :(context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
      initialRoute: WelcomeScreen.id,

    );
  }
}
