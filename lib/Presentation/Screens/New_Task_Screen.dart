import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Data/Models/Task_By_Status_Data.dart';
import 'package:taskmanager/Presentation/Controllers/Count_Task_By_Status_Controller.dart';
import 'package:taskmanager/Presentation/Controllers/New_Task_Controller.dart';
import 'package:taskmanager/Presentation/Screens/Add_New_Task_Screen.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';
import 'package:taskmanager/Presentation/Widget/Background_Widget.dart';
import 'package:taskmanager/Presentation/Widget/Empty_List_Widget.dart';
import 'package:taskmanager/Presentation/Widget/Profile_App_Bar.dart';
import 'package:taskmanager/Presentation/Widget/Task_Card.dart';
import 'package:taskmanager/Presentation/Widget/Task_Counter_Card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}
bool _updateTaskInProgress = false;

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    getDataFromApi();
    super.initState();
  }

  void getDataFromApi() async {
    Get.find<CountTaskByStatusController>().getCountByTaskStatus();
    Get.find<NewTaskController>().getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(),
      body: BackgroundWidget(
          child: Column(
        children: [
          GetBuilder<CountTaskByStatusController>(
              builder: (countTaskByStatusController) {
            return Visibility(
                visible: countTaskByStatusController.inProgress == false,
                replacement: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ),
                child: taskCounterSection(countTaskByStatusController
                        .countByStatusWrapper.listOfTaskStatusData ??
                    []));
          }),
          Expanded(
            child: GetBuilder<NewTaskController>(builder: (newTaskController) {
              return Visibility(
                visible: newTaskController.inProgress == false &&
                    _updateTaskInProgress == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: RefreshIndicator(
                  onRefresh: () async => getDataFromApi(),
                  child: Visibility(
                    visible: newTaskController
                            .newTaskListWrapper.taskList?.isNotEmpty ??
                        false,
                    replacement: const EmptyListWidget(),
                    child: ListView.builder(
                        itemCount: newTaskController
                                .newTaskListWrapper.taskList?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return TaskCard(
                              color: ColorGreen,
                              taskItems: newTaskController
                                  .newTaskListWrapper.taskList![index],
                              refreshList: () {
                                getDataFromApi();
                              });
                        }),
                  ),
                ),
              );
            }),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: ColorBlue,
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewTaskScreen(),
                ));
          },
          label: const Text("Add")),
    );
  }

  Widget taskCounterSection(
      List<TaskCountBuyStatusData> listOfTaskCountBuyStatusData) {
    return SizedBox(
      height: 130,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: listOfTaskCountBuyStatusData.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) {
            return const SizedBox(width: 5);
          },
          itemBuilder: (context, index) {
            return TaskCounterCard(
              title: listOfTaskCountBuyStatusData[index].sId ?? "",
              amount: listOfTaskCountBuyStatusData[index].sum ?? 0,
            );
          },
        ),
      ),
    );
  }
}
