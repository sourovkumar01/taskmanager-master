import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmanager/Data/Models/UserData.dart';
import 'package:taskmanager/Data/Service/Network_Caller.dart';
import 'package:taskmanager/Data/Utils/Urls.dart';
import 'package:taskmanager/Presentation/Controllers/Auth_Controllers.dart';
import 'package:taskmanager/Presentation/Screens/Main_Bottom_Nav_Screen.dart';
import 'package:taskmanager/Presentation/Screens/New_Task_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';
import 'package:taskmanager/Presentation/Widget/Background_Widget.dart';
import 'package:taskmanager/Presentation/Widget/Profile_App_Bar.dart';
import 'package:taskmanager/Presentation/Widget/SnackBar_Message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  XFile? pickedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    _emailController.text = AuthControllers.userData?.email ?? "";
    _firstNameController.text = AuthControllers.userData?.firstName ?? "";
    _lastNameController.text = AuthControllers.userData?.lastName ?? "";
    _mobileController.text = AuthControllers.userData?.mobile ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(isUpdateScreen: true),
      resizeToAvoidBottomInset: false,
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text("Update Profile",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  imagePickButton(),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: false,
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: "Email"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter frist name";
                      }
                      return null;
                    },
                    controller: _firstNameController,
                    decoration: const InputDecoration(hintText: "Frist Name"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter last name";
                      }
                      return null;
                    },
                    controller: _lastNameController,
                    decoration: const InputDecoration(hintText: "Last Name"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter mobile";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: _mobileController,
                    decoration: const InputDecoration(hintText: "Mobile"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration:
                        const InputDecoration(hintText: "Password (Optional)"),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _updateProfileInProgress == false,
                      replacement:
                          const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _updateProfile();
                          }
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imagePickButton() {
    return GestureDetector(
      onTap: () {
        pickImageFromGallery();
      },
      child: Container(
        decoration: BoxDecoration(
            color: ColorWhite, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: ColorDarkBlue,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8))),
            child: const Text("Photo",
                style: TextStyle(color: ColorLight, fontSize: 15)),
          ),
          const SizedBox(width: 8),
          Text(
            pickedImage?.name ?? "Unknown",
            maxLines: 1,
            style: const TextStyle(
                fontSize: 16,
                color: ColorLightGray,
                overflow: TextOverflow.ellipsis),
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> _updateProfile() async {
    String? photo;
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> inputParams = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
    };
    if (_passwordController.text.isNotEmpty) {
      inputParams["password"] = _passwordController.text;
    }

    if (pickedImage != null) {
      List<int> bytes = File(pickedImage!.path).readAsBytesSync();
      photo = base64Encode(bytes);
      inputParams["photo"] = photo;
    }
    final response =
        await NetworkCaller.postRequest(Urls.updateProfile, inputParams);
    _updateProfileInProgress = false;
    if (response.isSuccess) {
      if (response.ResponseBody["status"] == "success") {
        UserData userData = UserData(
            email: _emailController.text,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            mobile: _mobileController.text.trim(),
            photo: photo);
        await AuthControllers.SaveUserData(userData);
      }
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainBottomNavScreen(),
            ),
            (route) => false);
      }
    } else {
      if (!mounted) {
        return;
      }
      setState(() {});
      showSnackBarMessage(context, "update profile failed");
    }
  }
}
