import 'package:flutter/material.dart';
import 'package:tugas_16_api/extension/navigation.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';
import 'package:tugas_16_api/utils/gambar.dart';
import 'package:tugas_16_api/views/auth_screen/halaman.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }

  void checkLogin() async {
    final isLogin = await PreferenceHandler.getLogin();
    Future.delayed(const Duration(seconds: 3)).then((_) {
      print(isLogin);
      if (!mounted) return;

      if (isLogin == true) {
        context.pushReplacementNamed(BotnavPage.id);
      } else {
        context.pushNamed(HalamanMulai.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImage.logo),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
