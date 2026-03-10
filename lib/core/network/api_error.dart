//
// class ApiError {
//   final int ?statusCode;
//   final String message;
//
//   ApiError({  required this.message,this.statusCode});
//
//    @override
//   String toString (){
//     return message ;
//   }
//
// }


class ApiError {
  final int ?statusCode;
  final String message;

  ApiError({  required this.message,this.statusCode});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
    );
  }}