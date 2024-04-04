import 'package:taskmanager/Data/Models/UserData.dart';

class LoginResponse {
  String? status;
  String? token;
  UserData? userdata;

  LoginResponse({this.status, this.token, this.userdata});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    userdata =
        json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}
