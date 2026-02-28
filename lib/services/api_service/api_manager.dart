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

  final _headers = {"Content-Type": "application/json"};

  Future<http.Response> get({required String endpoint}) {
    print("url ${baseUrl + endpoint}");
    return http.get(Uri.parse(baseUrl + endpoint), headers: _headers);
  }

  Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
  }) {
    print("url ${baseUrl + endpoint}");
    return http.post(
      Uri.parse(baseUrl + endpoint),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put({
    required String endpoint,
    required Map<String, dynamic> body,
  }) {
    print("url ${baseUrl + endpoint}");

    return http.put(
      Uri.parse(baseUrl + endpoint),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete({required String endpoint}) {
    print("url ${baseUrl + endpoint}");

    return http.delete(Uri.parse(baseUrl + endpoint), headers: _headers);
  }
}
