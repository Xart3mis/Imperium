import 'package:flutter/material.dart';

import 'package:smart_rgb/screens/cant_find_device/cant_find_device_help.dart';
import 'package:smart_rgb/screens/settings/settings_screen.dart';
import 'package:smart_rgb/screens/my_devices/available_devices.dart';
import 'package:smart_rgb/screens/add_device/add_device.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddDeviceScreen()));
          }),
      appBar: AppBar(title: const Text("My Devices"), actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SettingsScreen(),
            ),
          ),
        ),
      ]),
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: AvailableDevices(),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CantFindDeviceHelp(),
                ),
              ),
              child: Text(
                "Can't find your device?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
