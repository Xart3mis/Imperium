import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:http/http.dart' as http;

class DevicePage extends StatefulWidget {
  final String deviceTitle, deviceAddress;
  const DevicePage(
      {super.key, required this.deviceTitle, required this.deviceAddress});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  Color selectedColor = Colors.purple;
  final throttler = Throttler(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deviceTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Align(
            alignment: Alignment.topCenter,
            child: ColorPicker(
              hasBorder: true,
              crossAxisAlignment: CrossAxisAlignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              color: selectedColor,
              enableShadesSelection: true,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.accent: false,
                ColorPickerType.primary: false,
                ColorPickerType.wheel: true,
              },
              onColorChanged: (color) => throttler.run(
                () => setState(() {
                  print(Uri.parse("http://${widget.deviceAddress}/setColor"));
                  selectedColor = color;
                  http.post(
                    Uri.parse("http://${widget.deviceAddress}/setColor"),
                    headers: <String, String>{
                      "Content-Type": "application/x-www-form-urlencoded",
                    },
                    body: <String, String>{
                      'red': selectedColor.red.toString(),
                      'blue': selectedColor.blue.toString(),
                      'green': selectedColor.green.toString(),
                    },
                  );
                }),
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class Throttler {
  final int milliseconds;

  int _lastActionTime;

  int get _millisecondsSinceEpoch => DateTime.now().millisecondsSinceEpoch;

  Throttler({required this.milliseconds})
      : _lastActionTime = DateTime.now().millisecondsSinceEpoch;

  void run(void Function() action) {
    if (_millisecondsSinceEpoch - _lastActionTime > milliseconds) {
      action();
      _lastActionTime = _millisecondsSinceEpoch;
    }
  }
}
