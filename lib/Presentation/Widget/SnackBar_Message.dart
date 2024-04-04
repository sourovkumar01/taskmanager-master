import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';

void showSnackBarMessage(BuildContext context, String message,
    [bool isErrorMessage = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(message),
        backgroundColor: isErrorMessage ? ColorRed : null),
  );
}
