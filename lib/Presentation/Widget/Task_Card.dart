import 'package:flutter/material.dart';
import 'package:taskmanager/Data/Models/Task+ITems.dart';
import 'package:taskmanager/Data/Service/Network_Caller.dart';
import 'package:taskmanager/Data/Utils/Urls.dart';
import 'package:taskmanager/Presentation/Utils/Style.dart';
import 'package:taskmanager/Presentation/Widget/SnackBar_Message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskItems,
    required this.color,
    required this.refreshList,
  });

  final Color color;
  final TaskItems taskItems;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

bool _updateTaskInProgress = false;
bool _deleteTaskProgress = false;

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Card(
        child: Container(
          height: 150,
          decoration: BoxDecoration(
              color: ColorWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 25)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.taskItems.title ?? "Unknown",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.taskItems.description ??
                            "please enter any description for good work",maxLines: 2,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                            color: ColorLightGray, fontSize: 15),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.color),
                          child: Expanded(
                              child: Text(
                            widget.taskItems.status ?? "",
                          )),
                        ),
                      ),
                      Text(
                        widget.taskItems.createdDate ??
                            "please enter any description for good work",
                        style: const TextStyle(
                            color: ColorLightGray, fontSize: 15),
                      ),
                      Wrap(children: [
                        Visibility(
                          visible: _updateTaskInProgress == false,
                          replacement: const CircularProgressIndicator(),
                          child: IconButton(
                            onPressed: () {
                              _showUpdateStatusDialog(widget.taskItems.sId!);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: ColorDarkBlue,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _deleteTaskProgress == false,
                          replacement: const CircularProgressIndicator(),
                          child: IconButton(
                            onPressed: () {
                              deleteTaskById(widget.taskItems.sId!);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: ColorRed,
                            ),
                          ),
                        ),
                      ])
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  bool _isCurrentStatus(String status) {
    return widget.taskItems.status == status;
  }

  void _showUpdateStatusDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("New"),
                trailing: _isCurrentStatus("New") ? const Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("New")) {
                    return;
                  }
                  updateTaskById(id, "New");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Completed"),
                trailing: _isCurrentStatus("Completed") ? const Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("Completed")) {
                    return;
                  }
                  updateTaskById(id, "Completed");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Progress"),
                trailing: _isCurrentStatus("Progress") ? const Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("Progress")) {
                    return;
                  }
                  updateTaskById(id, "Progress");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Cancelled"),
                trailing: _isCurrentStatus("Cancelled") ? const Icon(Icons.check) : null,
                onTap: () {
                  if (_isCurrentStatus("Cancelled")) {
                    return;
                  }
                  updateTaskById(id, "Cancelled");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateTaskById(String id, String status) async {
    _updateTaskInProgress = true;
    setState(() {});
    final response =
        await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    _updateTaskInProgress = false;
    if (response.isSuccess) {
      _updateTaskInProgress = false;
      widget.refreshList();
    } else {
      if (mounted) {
        showSnackBarMessage(context, "Update Task Status has been failed!");
      }
    }
  }

  Future<void> deleteTaskById(String id) async {
    _deleteTaskProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.deleteTask(id));
    _deleteTaskProgress = false;
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      if (mounted) {
        showSnackBarMessage(context, "Delete Task has been failed!");
      }
    }
  }
}
