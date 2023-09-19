import 'package:flutter/material.dart';
import 'package:smart_rgb/components/help/help_widget.dart';

class CantFindDeviceHelp extends StatelessWidget {
  const CantFindDeviceHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
      ),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: HelpWidget(
          title: Text(
            "Can't find your device?",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          entries: [
            Text(
                "Make sure you're connected to the same network as your device."),
            Text("Make sure your device is compatible with the app."),
            Text("If the problem persists, please reboot your device."),
          ],
        ),
      ),
    );
  }
}
