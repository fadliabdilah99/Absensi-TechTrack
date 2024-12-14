import 'dart:async';

import 'package:absensi_apps/config/app_asset.dart';
import 'package:absensi_apps/config/app_color.dart';
import 'package:absensi_apps/config/session.dart';
import 'package:absensi_apps/data/model/user.dart';
import 'package:absensi_apps/presentation/page/absens/absenpage.dart';
import 'package:absensi_apps/presentation/page/auth/login_page.dart';
import 'package:absensi_apps/presentation/page/homepage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 6), () async {
      await _checkUserAndNavigate();
    });
  }

  Future<void> _checkUserAndNavigate() async {
    User? user = await Session.getUser();
    if (user != null && user.idUser != null && user.idUser!.isNotEmpty) {
      Get.offAll( ProfilePage());
    } else {
      Get.offAll( LoginPage());
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Absensi Apps',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: AppColor.secondary.withOpacity(0.5),
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'By TechTrack',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.secondary,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                ),
                LottieBuilder.asset(
                  AppAsset.openign,
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
