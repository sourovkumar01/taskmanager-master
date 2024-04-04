import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskmanager/Presentation/Controllers/Auth_Controllers.dart';
import 'package:taskmanager/Presentation/Screens/Auth/Sing_In_Screen.dart';
import 'package:taskmanager/Presentation/Screens/Main_Bottom_Nav_Screen.dart';
import 'package:taskmanager/Presentation/Widget/App_Logo.dart';
import 'package:taskmanager/Presentation/Widget/Background_Widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const AppLogo(),
             Lottie.network(
                 "https://lottie.host/572f473d-b348-4e88-9e74-6f7c67aa1353/PfSA0NOtME.json",
                 fit: BoxFit.cover),
           ],
        ),
      ),)
    );
  }

  Future<void> goToNextPage() async {
    await Future.delayed(const Duration(seconds: 5));
    bool isLoggedIn = await AuthControllers.isUserLoggedin();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const MainBottomNavScreen() : const SingInScreen(),
        ),
      );
    }
  }
}
