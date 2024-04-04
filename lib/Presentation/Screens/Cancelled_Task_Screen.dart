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

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}
bool _taskListWrapperInProgress = false;
bool _updateTaskInProgress = false;

TaskListWrapper _cancelledTaskListWrapper = TaskListWrapper();

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  @override
  void initState() {
    getDataFromApi();
    super.initState();
  }

  void getDataFromApi() async {
    getAllTaskCancelledList();
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
                    child: Visibility(visible: _cancelledTaskListWrapper.taskList?.isNotEmpty ?? false,
                      replacement: const EmptyListWidget(),
                      child: ListView.builder(
                          itemCount: _cancelledTaskListWrapper.taskList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskCard(
                                color: ColorRed,
                                taskItems: _cancelledTaskListWrapper.taskList![index],
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



  Future<void> getAllTaskCancelledList() async {
    setState(() {
      _taskListWrapperInProgress = true;
    });
    final response = await NetworkCaller.getRequest(Urls.cancelledTaskList);
    if (response.isSuccess) {
      _cancelledTaskListWrapper = TaskListWrapper.fromJson(response.ResponseBody);
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
