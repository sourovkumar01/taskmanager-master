import 'package:flutter/material.dart';
import 'package:taskmanager/Presentation/Utils/Assets_Path.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.AppLogoPng,
    );
  }
}
