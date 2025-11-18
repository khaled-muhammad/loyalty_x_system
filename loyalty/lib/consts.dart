import 'package:dio/dio.dart';

// Plz change base url before running the flutter app to avoid any issues and make it match your device ip
final dio = Dio(BaseOptions(baseUrl: 'https://loyalty-x-system.onrender.com/api/'));
// final dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.30:43858/api/'));