import 'package:flutter/material.dart';
import 'package:taskmanager/Presentation/Screens/Cancelled_Task_Screen.dart';
import 'package:taskmanager/Presentation/Screens/Completed_Task_Screen.dart';
import 'package:taskmanager/Presentation/Screens/New_Task_Screen.dart';
import 'package:taskmanager/Presentation/Screens/Progress_Task_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    const NewTaskScreen(),
    const CompletedTaskScreen(),
    const ProgressTaskScreen(),
    const CancelledTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          // type: BottomNavigationBarType.fixed,
          //   backgroundColor: ColorDarkBlue,
          selectedItemColor: ColorDarkBlue,
          unselectedItemColor: ColorLightGray,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            if (mounted) {
              setState(() {});
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "New Task"),
            BottomNavigationBarItem(
                icon: Icon(Icons.task_alt), label: "Completed"),
            BottomNavigationBarItem(
                icon: Icon(Icons.pending_outlined), label: "Progress"),
            BottomNavigationBarItem(
                icon: Icon(Icons.cancel_outlined), label: "Cancelled"),
          ]),
    );
  }
}
