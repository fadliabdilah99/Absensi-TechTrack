import 'package:absensi_apps/config/api.dart';
import 'package:absensi_apps/config/app_request.dart';
import 'package:absensi_apps/config/session.dart';
import 'package:absensi_apps/data/model/user.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';

class SourceUser {
  static Future<bool> login(String email, String password) async {
    String url = '${Api.user}/login';
    Map? responseBody = await AppRequest.post(url, {
      'email': email,
      'password': password,
    });
    if (responseBody == null) return false;

    if (responseBody['success']) {
      // jika login berhasil simpan data ke session
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));
    }

    return responseBody['success'];
  }

  static Future<Map> getstatus(String idUser) async {
    String url = '${Api.user}/status';
    Map? responseBody = await AppRequest.post(url, {
      'id_user': idUser,
    });
    if (responseBody == null) return {'success': false};
    return responseBody;
  }
}
