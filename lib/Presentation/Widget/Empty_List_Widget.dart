import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      "Empty List",
      style: TextStyle(fontSize: 24,),
    ));
  }
}
