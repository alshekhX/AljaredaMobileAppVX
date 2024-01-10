import 'package:dio/dio.dart';
import 'package:sizer/sizer.dart';

class AljaredaConst {
  // ignore: non_constant_identifier_names
  static String NetworkBaseUrL = "http://192.168.252.52:8000";
  static String BasePicUrl = 'http://192.168.252.52:8000/uploads/photos/';

  BaseOptions option = BaseOptions(
    baseUrl: NetworkBaseUrL,
    connectTimeout: Duration(seconds: 8) ,
    receiveTimeout:  Duration(seconds: 8),
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  GetdioX() {
    return Dio(option);
  }

  final double pagePadding = 6.w;
    final double headLinePadding = 5.w;
        final double bottomNavText = 18;


}
