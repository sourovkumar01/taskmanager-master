import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:taskmanager/Presentation/Screens/Auth/Email_verification_Screen.dart';
import 'package:taskmanager/Presentation/Controllers/Sing_In_Controller.dart';
import 'package:taskmanager/Presentation/Screens/Auth/Sing_Up_Screen.dart';
import 'package:taskmanager/Presentation/Screens/Main_Bottom_Nav_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';
import 'package:taskmanager/Presentation/Widget/Background_Widget.dart';
import 'package:taskmanager/Presentation/Widget/SnackBar_Message.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({super.key});

  @override
  State<SingInScreen> createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final SingInController _singInController = Get.find<SingInController>();

@override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter you email";
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter you Password";
                      }
                      if (value.length <= 6) {
                        return "Password shud be 6 charracters";
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<SingInController>(
                        builder: (singInController) {
                      return Visibility(
                        visible: singInController.inProgress == false,
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                _singIn();
                              }
                            },
                            child:
                                const Icon(Icons.arrow_circle_right_outlined)),
                      );
                    }),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: ColorLightGray),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EmailVerificationScreen(),
                            ));
                      },
                      child: const Text(
                        "Forget Password ?",
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SingUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sing up",
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _singIn() async {
    final result = await _singInController.singIn(
        _emailController.text.trim(), _passwordController.text);
    if (result) {
      if (mounted) {
        showSnackBarMessage(context, "Login Successful");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainBottomNavScreen(),
            ),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, _singInController.errorMessage);
      }
    }
  }
}
