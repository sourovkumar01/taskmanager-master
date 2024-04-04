import 'package:flutter/material.dart';
import 'package:taskmanager/Data/Service/Network_Caller.dart';
import 'package:taskmanager/Data/Utils/Urls.dart';
import 'package:taskmanager/Presentation/Screens/Auth/Sing_In_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';
import 'package:taskmanager/Presentation/Widget/Background_Widget.dart';
import 'package:taskmanager/Presentation/Widget/SnackBar_Message.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _setPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  "Set Password",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                const Text(
                  "Minimum 8 characters with letters and number combination",
                  style: TextStyle(color: ColorLightGray),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(hintText: "Confirm Password"),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(visible: _setPasswordInProgress == false,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: () {
                        setPasswordApi();
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SingInScreen(),
                            ),
                            (route) => false);
                      },
                      child: const Text(
                        "Sing in",
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> setPasswordApi() async {
    _setPasswordInProgress = true;
    setState(() {});
    Map<String, dynamic> inputParams = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _passwordController.text
    };
    final response =
        await NetworkCaller.postRequest(Urls.recoverResetPass, inputParams);
    _setPasswordInProgress = false;
    if (response.isSuccess) {
      setState(() {});
      if (!mounted) {
        return;
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SingInScreen(),
          ),
          (route) => false);
      showSnackBarMessage(context, 'Password reset successful');

    } else {
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context, "Invalid password", true);
      }
    }
  }
}
