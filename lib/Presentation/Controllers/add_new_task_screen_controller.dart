import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Data/Service/Network_Caller.dart';
import 'package:taskmanager/Data/Utils/Urls.dart';
import 'package:taskmanager/Presentation/Controllers/Count_Task_By_Status_Controller.dart';
import 'package:taskmanager/Presentation/Controllers/New_Task_Controller.dart';
import 'package:taskmanager/Presentation/Widget/SnackBar_Message.dart';

class AddNewTaskScreenController extends GetxController {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool addNewTaskInProgress = false;


  Future<void> addNewTask(BuildContext context) async {
      addNewTaskInProgress = true;
      update();
    Map<String, dynamic> inputParams = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "status": "New",
    };
    final response =
    await NetworkCaller.postRequest(Urls.createTask, inputParams);
      addNewTaskInProgress = false;
      update();
    if (response.isSuccess) {
      if (context.mounted) {
        showSnackBarMessage(context, "Task Added Successful");
        Get.find<CountTaskByStatusController>().getCountByTaskStatus();
        Get.find<NewTaskController>().getNewTaskList();
      }
    } else {
      if (context.mounted) {
        showSnackBarMessage(
            context, response.ErrorMessage ?? "Task added failed", true);
      }
    }
    update();
  }


}