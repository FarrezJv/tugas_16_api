import 'package:flutter/material.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';
import 'package:tugas_16_api/utils/gambar.dart';
import 'package:tugas_16_api/views/login.dart';
import 'package:tugas_16_api/widgets/botnav.dart';

class Day16SplashScreen extends StatefulWidget {
  const Day16SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<Day16SplashScreen> createState() => _Day16SplashScreenState();
}

class _Day16SplashScreenState extends State<Day16SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print(isLogin);
      if (isLogin == true) {
        context.pushReplacementNamed(BotnavPage.id);
      } else {
        context.push(LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.logo),
              SizedBox(height: 20),
              // Text("Welcome"),
            ],
          ),
        ),
      ),
    );
  }
}
