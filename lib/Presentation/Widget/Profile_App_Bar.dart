import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taskmanager/App.dart';
import 'package:taskmanager/Presentation/Controllers/Auth_Controllers.dart';
import 'package:taskmanager/Presentation/Screens/Auth/Sing_In_Screen.dart';
import 'package:taskmanager/Presentation/Screens/Update_Profile_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';

AppBar profileAppBar({bool isUpdateScreen = false}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: ColorGreen,
    title: GestureDetector(
      onTap: () {
        if (isUpdateScreen == true) {
          return;
        }
        Navigator.push(
            TaskManager.navigatorKey.currentState!.context,
            MaterialPageRoute(
              builder: (context) => const UpdateProfileScreen(),
            ));
      },
      child: Row(children: [
        CircleAvatar(
          backgroundImage: (AuthControllers.userData!.photo) != null
              ? MemoryImage(base64Decode(AuthControllers.userData!.photo!
                  .split('data:image/png;base64,')
                  .last))
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AuthControllers.userData?.fullName ?? "Unknown",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                AuthControllers.userData?.email ?? "",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
        IconButton(
          onPressed: () {
            AuthControllers.ClearUserData();
            Navigator.pushAndRemoveUntil(
                TaskManager.navigatorKey.currentState!.context,
                MaterialPageRoute(
                  builder: (context) => const SingInScreen(),
                ),
                (route) => false);
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ]),
    ),
  );
}
