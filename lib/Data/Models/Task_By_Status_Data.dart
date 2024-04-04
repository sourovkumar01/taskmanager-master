
class TaskCountBuyStatusData {
  String? sId;
  int? sum;

  TaskCountBuyStatusData({this.sId, this.sum});

  TaskCountBuyStatusData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }
}
