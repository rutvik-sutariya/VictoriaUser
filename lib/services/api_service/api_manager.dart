import 'dart:async';
import 'dart:convert';
import 'package:victoria_user/services/constants.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();

  ApiManager._internal();

  static ApiManager get instance => _instance;

  static final String baseUrl = Config.baseUrl;

  final _header1 = {"Content-Type": "application/json"};
  final _header2 = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${Constant.token.value}',
  };

  Future<http.Response> get({required String endpoint, required bool headers}) {
    print("url ${baseUrl + endpoint}");
    print("headers ${headers ? _header2 : _header1}");
    return http.get(
      Uri.parse(baseUrl + endpoint),
      headers: headers ? _header2 : _header1,
    );
  }

  Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    required bool headers,
  }) {
    print("url ${baseUrl + endpoint}");
    return http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers ? _header2 : _header1,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put({
    required String endpoint,
    required Map<String, dynamic> body,
    required bool headers,
  }) {
    print("url ${baseUrl + endpoint}");
    print("headers ${headers ? _header2 : _header1}");
    return http.put(
      Uri.parse(baseUrl + endpoint),
      headers: headers ? _header2 : _header1,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete({
    required String endpoint,
    required bool headers,
  }) {
    print("url ${baseUrl + endpoint}");
    print("headers ${headers ? _header2 : _header1}");
    return http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: headers ? _header2 : _header1,
    );
  }
}
