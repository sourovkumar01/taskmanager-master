import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskmanager/Presentation/Utils/Assets_Path.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, this.child});

  final child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SvgPicture.asset(
        AssetsPath.backgroundSvg,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      child,
    ]);
  }
}
