class ResponseObject {
  final bool isSuccess;
  final int statusCode;
  final dynamic ResponseBody;
   String? ErrorMessage;

  ResponseObject(
      {required this.isSuccess,
      required this.statusCode,
      required this.ResponseBody,
       this.ErrorMessage});
}
