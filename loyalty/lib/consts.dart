import 'package:dio/dio.dart';

// Plz change base url before running the flutter app to avoid any issues and make it match your device ip
final dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.26:3012/api/'));