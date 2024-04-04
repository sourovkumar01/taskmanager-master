import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:taskmanager/Data/Service/Network_Caller.dart';
import 'package:taskmanager/Data/Utils/Urls.dart';
import 'package:taskmanager/Presentation/Screens/Auth/Set_Password_Screen.dart';
import 'package:taskmanager/Presentation/Screens/Auth/Sing_In_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';
import 'package:taskmanager/Presentation/Widget/Background_Widget.dart';
import 'package:taskmanager/Presentation/Widget/SnackBar_Message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _pinverifyInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  "Pin Verification",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                const Text(
                  "A 6 Digits verification code will be sent to your email address",
                  style: TextStyle(color: ColorLightGray),
                ),
                const SizedBox(height: 45),
                PinCodeTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter otp";
                    }
                    return null;
                  },
                  controller: _pinController,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: ColorWhite,
                    inactiveColor: ColorGreen,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {},
                  appContext: context,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: _pinverifyInProgress == false,
                    replacement:
                        const Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _receivedOtp();
                        }
                      },
                      child: const Text(
                        "Verify",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SingInScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Sign in",
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
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _receivedOtp() async {
    setState(() {
      _pinverifyInProgress = true;
    });
    final response = await NetworkCaller.getRequest(
        Urls.receivedSendOtp(widget.email, _pinController.text));
    _pinverifyInProgress = false;
    setState(() {});
    if (response.ResponseBody['status'] == 'success') {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetPasswordScreen(
                  email: widget.email, otp: _pinController.text),
            ));
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, "wrong otp");
      }
    }
  }
}
