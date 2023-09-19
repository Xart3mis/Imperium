import 'package:flutter/material.dart';
import 'package:smart_rgb/screens/device/device_page.dart';
import 'package:get/get.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String deviceInfo;
  final String deviceAddress;

  const DeviceCard(
      {super.key, required this.deviceName, required this.deviceInfo, required this.deviceAddress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DevicePage(deviceTitle: deviceInfo, deviceAddress: deviceAddress),
            ),
          );
        },
        splashColor: Theme.of(context).colorScheme.tertiary.withAlpha(50),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    Text(
                      "Local Device",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Image(
                          image: Get.isDarkMode
                              ? const AssetImage("images/control_inverted.png")
                              : const AssetImage("images/control.png"),
                          width: 75,
                        ),
                      ),
                      Expanded(
                        child: IntrinsicWidth(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                deviceName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              // const SizedBox(height: 5),
                              Text(
                                deviceInfo,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
