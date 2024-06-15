import 'dart:convert';

import 'package:http/http.dart' as http;

class Auth {
  String? token, name, message;
  int? status, isAdmin;

  Auth(
      {required this.token,
      required this.isAdmin,
      required this.name,
      required this.message,
      required this.status});

  factory Auth.authResult(Map<String, dynamic> object) {
    if (object['status'] == 200) {
      return Auth(
          token: object['token'],
          message: object['message'],
          status: object['status'],
          name: object['user']['name'],
          isAdmin: object['user']['is_admin']);
    } else {
      return Auth(
          token: null,
          message: object['message'],
          status: object['status'],
          isAdmin: null,
          name: null);
    }
  }

  static Future<Auth> postLogin(
      {required String email, required String password}) async {
    Uri url = Uri.parse('http://192.168.239.136:8000/api/login');
    var response =
        await http.post(url, body: {"email": email, "password": password});
    var jsonObject = json.decode(response.body);
    return Auth.authResult(jsonObject);
  }
}
