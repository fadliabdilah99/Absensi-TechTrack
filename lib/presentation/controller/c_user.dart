import 'dart:convert';

import 'package:absensi_apps/data/model/user.dart';
import 'package:absensi_apps/data/source/source_user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Cuser extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _status = ''.obs;
  String get status => _status.value;

  final _data = User().obs;
  User get data => _data.value;

  Future<void> getstatus(String idUser) async {
    _loading.value = true;
    update();

    Map response = await SourceUser.getstatus(idUser);

    if (response['success']) {
      _status.value = response['data']['status'];
    } else {
      // Handle error
    }

    _loading.value = false;
    update();
  }

  // Fungsi untuk mengambil status absensi terbaru
  Future<void> fetchAbsensiStatus() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.example.com/status/${data.idUser}')); // Sesuaikan dengan URL API status

      if (response.statusCode == 200) {
        // Misalnya, status absensi ada di dalam respon
        var responseData = json.decode(response.body);
        String statusAbsen = responseData['status']; // Ambil status dari API
        _data.value.status =
            statusAbsen; // Update status absensi pada data user
      } else {
        throw Exception('Gagal memuat status absensi');
      }
    } catch (e) {
      print('Error fetching absensi status: $e');
    }
  }

  // Fungsi untuk memperbarui data pengguna
  setData(User user) {
    _data.value = user;
  }
}
