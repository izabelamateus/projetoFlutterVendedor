import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto_flutter/pages/splash.dart';
import 'package:provider/provider.dart';
import './pages/home_page.dart';
import './pages/lista_produtos.dart';
import './pages/login_page.dart';
import 'controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MaterialApp(
        title: 'Login',
        theme: ThemeData(
          primaryColor: Color(0xFFF2622E),
          accentColor: Color(0xFFF2C6A0),
        ),
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
