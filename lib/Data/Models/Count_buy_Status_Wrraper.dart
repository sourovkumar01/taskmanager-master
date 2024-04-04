import 'package:taskmanager/Data/Models/Task_By_Status_Data.dart';

class CountBuyTaskWrapper {
  String? status;
  List<TaskCountBuyStatusData>? listOfTaskStatusData;

  CountBuyTaskWrapper({this.status, this.listOfTaskStatusData});

  CountBuyTaskWrapper.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      listOfTaskStatusData = <TaskCountBuyStatusData>[];
      json['data'].forEach((v) {
        listOfTaskStatusData!.add(TaskCountBuyStatusData.fromJson(v));
      });
    }
  }
}