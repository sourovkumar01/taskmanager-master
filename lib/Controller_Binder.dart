import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:taskmanager/Presentation/Controllers/Count_Task_By_Status_Controller.dart';
import 'package:taskmanager/Presentation/Controllers/New_Task_Controller.dart';
import 'package:taskmanager/Presentation/Controllers/Sing_In_Controller.dart';
import 'package:taskmanager/Presentation/Controllers/add_new_task_screen_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SingInController());
    Get.lazyPut(() => CountTaskByStatusController());
     Get.lazyPut(() => NewTaskController());
     Get.lazyPut(() => AddNewTaskScreenController());

  }
}
