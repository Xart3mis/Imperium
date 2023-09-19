import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:smart_rgb/screens/my_devices/devices_page.dart';
import 'package:smart_rgb/screens/login/login_page.dart';
import 'package:smart_rgb/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Permission.location.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("FirstName");
  }

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("ThemeMode");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getThemeMode(),
      builder: (context, snapshot) {
        var tm = ThemeMode.system;

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          tm = (snapshot.data ?? "System") == "System"
              ? ThemeMode.system
              : (snapshot.data! == "Dark"
                  ? ThemeMode.dark
                  : snapshot.data! == "Light"
                      ? ThemeMode.light
                      : ThemeMode.system);
        }

        return GetMaterialApp(
          title: "Imperium",
          home: FutureBuilder(
            future: getFirstName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return (snapshot.data ?? "").isEmpty
                    ? const LoginPage(destination: DevicesPage())
                    : const DevicesPage();
              }

              return FutureBuilder(
                future: Future<Widget>.delayed(
                  const Duration(milliseconds: 50),
                  () async {
                    return const LoginPage(destination: DevicesPage());
                  },
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return snapshot.data ?? Container();
                  }

                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                },
              );
            },
          ),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: tm,
        );
      },
    );
  }
}
