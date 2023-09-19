import 'package:shared_preferences/shared_preferences.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("ThemeMode");
  }

  Future<bool> setThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString("ThemeMode", themeMode);
  }
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    widget
        .getThemeMode()
        .then((value) => setState(() => dropdownValue = value ?? "System"));

    return Scaffold(
      appBar: AppBar(title: const Text("Appearance")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 4,
            child: UnDraw(
              illustration: UnDrawIllustration.color_palette,
              color: Get.theme.colorScheme.secondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: DropdownButton<String>(
              value: dropdownValue,
              items: [
                DropdownMenuItem<String>(
                  value: "System",
                  child: const Text("System"),
                  onTap: () => Get.changeThemeMode(ThemeMode.system),
                ),
                DropdownMenuItem<String>(
                  value: "Dark",
                  child: const Text("Dark"),
                  onTap: () => Get.changeThemeMode(ThemeMode.dark),
                ),
                DropdownMenuItem<String>(
                  value: "Light",
                  child: const Text("Light"),
                  onTap: () => Get.changeThemeMode(ThemeMode.light),
                ),
              ],
              onChanged: (selection) {
                widget.setThemeMode(selection ?? "System").then((_) =>
                    setState(() => dropdownValue = selection ?? "System"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
