import 'package:flutter/material.dart';
import 'package:taskmanager/Data/Models/Task_List_Wrapper.dart';
import 'package:taskmanager/Data/Service/Network_Caller.dart';
import 'package:taskmanager/Data/Utils/Urls.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';
import 'package:taskmanager/Presentation/Widget/Background_Widget.dart';
import 'package:taskmanager/Presentation/Widget/Empty_List_Widget.dart';
import 'package:taskmanager/Presentation/Widget/Profile_App_Bar.dart';
import 'package:taskmanager/Presentation/Widget/SnackBar_Message.dart';
import 'package:taskmanager/Presentation/Widget/Task_Card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}
bool _taskListWrapperInProgress = false;
bool _updateTaskInProgress = false;

TaskListWrapper _completedTaskListWrapper = TaskListWrapper();

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    getDataFromApi();
    super.initState();
  }

  void getDataFromApi() async {
    getAllTaskCompletedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(),
      body: BackgroundWidget(
          child: Column(
            children: [
              Expanded(
                child: Visibility(
                  visible: _taskListWrapperInProgress == false &&
                      _updateTaskInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: () async => getDataFromApi(),
                    child: Visibility(visible: _completedTaskListWrapper.taskList?.isNotEmpty ?? false,
                      replacement: const EmptyListWidget(),
                      child: ListView.builder(
                          itemCount: _completedTaskListWrapper.taskList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskCard(
                                color: ColorBlue,
                                taskItems: _completedTaskListWrapper.taskList![index],
                                refreshList: () {
                                  getDataFromApi();
                                });
                          }),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }



  Future<void> getAllTaskCompletedList() async {
    setState(() {
      _taskListWrapperInProgress = true;
    });
    final response = await NetworkCaller.getRequest(Urls.completedTaskList);
    if (response.isSuccess) {
      _completedTaskListWrapper = TaskListWrapper.fromJson(response.ResponseBody);
      ;
      setState(() {
        _taskListWrapperInProgress = false;
      });
    } else {
      if (mounted) {
        showSnackBarMessage(context, "Sorry Task List Getting failed!");
      }
    }
  }
}


