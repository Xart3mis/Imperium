import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:smart_rgb/screens/settings/appearance.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: UnDraw(
              illustration: UnDrawIllustration.settings,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              shrinkWrap: true,
              children: [
                const ListTile(
                  leading: Icon(Icons.tune),
                  title: Text("General"),
                  trailing: Icon(Icons.arrow_right),
                ),
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text("Appearance"),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AppearanceSettings(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
