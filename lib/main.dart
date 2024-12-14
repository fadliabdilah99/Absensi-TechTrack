import 'package:absensi_apps/presentation/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_apps/config/app_color.dart';
// import 'package:money_record/presentation/page/history/addhistory.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  // // initializeDateFormatting('id_ID').then((value) {
  // //   runApp(const MyApp());
  // // });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 123, 165, 162),
          secondary: Color.fromARGB(255, 177, 221, 218),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 123, 165, 162),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const SplashPage(),
      // home: FutureBuilder(
      //   future: Session.getUser(),
      //   builder: (context, AsyncSnapshot<User> snapshot) {
      //     if (snapshot.data != null && snapshot.data!.idUser != null) {
      //       return const HomePage();
      //     }
      //     return const LoginPage();
      //   },
      // ),
    );
  }
}
