import 'package:get/get.dart';
import 'package:taskmanager/Data/Models/Count_buy_Status_Wrraper.dart';
import 'package:taskmanager/Data/Service/Network_Caller.dart';
import 'package:taskmanager/Data/Utils/Urls.dart';

class CountTaskByStatusController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;
  CountBuyTaskWrapper _countByStatusWrapper = CountBuyTaskWrapper();

  bool get inProgress => _inProgress;

  String? get errorMessage =>
      _errorMessage ?? "Fetch failed count by task status ";

  CountBuyTaskWrapper get countByStatusWrapper => _countByStatusWrapper;

  Future<bool> getCountByTaskStatus() async {
    bool isSuccess = false;

    _inProgress = true;
    update();
    final response = await NetworkCaller.getRequest(Urls.taskCountByStatus);
    _inProgress = true;

    if (response.isSuccess) {
      _countByStatusWrapper =
          CountBuyTaskWrapper.fromJson(response.ResponseBody);
      isSuccess = true;
    } else {
      _errorMessage = response.ErrorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
