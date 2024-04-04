import 'package:flutter/material.dart';
import 'package:taskmanager/Data/Service/Network_Caller.dart';
import 'package:taskmanager/Data/Utils/Urls.dart';
import 'package:taskmanager/Presentation/Screens/Auth/Pin_verification_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';
import 'package:taskmanager/Presentation/Widget/Background_Widget.dart';
import 'package:taskmanager/Presentation/Widget/SnackBar_Message.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _sendOtpInProgress = false;

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
                  "Enter Your Email",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                const Text(
                  "A 6 Digits verification code will be send your email address",
                  style: TextStyle(color: ColorLightGray),
                ),
                const SizedBox(height: 45),
                TextFormField(
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Please enter email";
                    }return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(visible: _sendOtpInProgress == false,
                    replacement:  const Center(child:CircularProgressIndicator() ),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formkey.currentState!.validate()) {
                          _sendOtp();
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
  void deactivate() {
    _emailController.dispose();
    super.deactivate();
  }

  Future<void> _sendOtp()async{
    setState(() {
      _sendOtpInProgress = true;
    });

    final response = await NetworkCaller.getRequest(
        Urls.sendOtp(_emailController.text.trim()));
    _sendOtpInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PinVerificationScreen(email: _emailController.text),
            ));
        showSnackBarMessage(context, "Otp send on your email");
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, "Send Otp is failed");
      }
    }
  }
}
