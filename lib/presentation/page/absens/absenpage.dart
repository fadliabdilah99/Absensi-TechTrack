import 'dart:io';
import 'package:absensi_apps/config/api.dart';
import 'package:absensi_apps/config/app_color.dart';
import 'package:absensi_apps/presentation/controller/c_user.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AbsensiApp());
}

class AbsensiApp extends StatelessWidget {
  const AbsensiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AbsensiScreen(),
    );
  }
}

class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({Key? key}) : super(key: key);

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  LocationData? _locationData;
  File? _foto;
  bool _isLoading = false;
  final cUser = Get.put(Cuser());
  String _statusAbsensi = '';

  /// Mengambil lokasi pengguna
  Future<void> _getLocation() async {
    final location = Location();

    if (!await location.serviceEnabled() && !await location.requestService()) {
      return;
    }

    if (await location.hasPermission() == PermissionStatus.denied &&
        await location.requestPermission() != PermissionStatus.granted) {
      return;
    }

    final locationData = await location.getLocation();
    setState(() {
      _locationData = locationData;
    });
  }

  /// Mengambil foto menggunakan kamera
  Future<void> _getPhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  /// Mengirim data absensi ke API
  Future<void> _submitAbsensi() async {
    if (_locationData == null || _foto == null) {
      _showSnackBar('Pastikan lokasi dan foto sudah diambil!');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(Api.absen), // Sesuaikan URL API Anda
      )
        ..fields['user_id'] = cUser.data.idUser
            .toString() // Ganti sesuai user ID dari sistem Anda
        ..fields['latitude'] = _locationData!.latitude.toString()
        ..fields['longitude'] = _locationData!.longitude.toString()
        ..files.add(await http.MultipartFile.fromPath('foto', _foto!.path));

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _statusAbsensi = "telah absen";
        });
        DInfo.dialogSuccess(context, 'Berhasil melakukan absensi!');
        DInfo.closeDialog(context, actionAfterClose: () {
          Get.offAll(() => AbsensiApp());
        });

        // Update status absensi pada data user setelah berhasil absen
        cUser.data.updateStatus("sudah absen"); // Memperbarui status absensi
      } else {
        _showSnackBar('Gagal melakukan absensi!');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan!');
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// Menampilkan pesan snack bar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg, // Latar belakang warna ungu tua elegan
      appBar: AppBar(
        title: const Text(
          'Absensi Masuk',
          style: TextStyle(color: AppColor.light),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _foto != null ? FileImage(_foto!) : null,
                      backgroundColor: Colors.grey.shade800,
                      child: _foto == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cUser.data.name.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Obx(
                        () {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: cUser.data.status == 'sudah absen'
                                  ? Colors.green
                                  : AppColor.secondary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              cUser.data.status ??
                                  'Belum Absen', // Menampilkan status absensi terbaru
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              if (_locationData != null)
                Column(
                  children: [
                    Text(
                      'Lokasi: ${_locationData!.latitude}, ${_locationData!.longitude}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ElevatedButton.icon(
                onPressed: _getLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF40407A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.white70),
                  ),
                ),
                icon: const Icon(Icons.location_on),
                label:
                    const Text('Get Location', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _getPhoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF40407A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.white70),
                  ),
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Pict', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitAbsensi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'send',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
