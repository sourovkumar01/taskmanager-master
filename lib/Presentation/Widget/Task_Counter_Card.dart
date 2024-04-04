import 'package:flutter/material.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';

class TaskCounterCard extends StatelessWidget {
  const TaskCounterCard({
    super.key,
    required this.amount,
    required this.title,
  });

  final int amount;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigoAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          children: [
            Text(
              "$amount",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28,color: ColorWhite),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: ColorLight),
            ),
          ],
        ),
      ),
    );
  }
}