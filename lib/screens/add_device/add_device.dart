import 'dart:async';
import 'dart:io';

import 'package:smart_rgb/components/animated_spinning_sync/spinning_icon_button.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:esptouch_flutter/esptouch_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late StreamSubscription connectivitySubscription;
  late FocusNode passphraseFocus;

  final NetworkInfo _networkInfo = NetworkInfo();

  String? wifiName, wifiBSSID, passphrase;

  bool passVisibility = true;

  @override
  void initState() {
    super.initState();

    getNetworkInfo();

    bool showed = false;
    int count = 0;
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
      getNetworkInfo();
      count++;
      if (count == 1) {
        showed = true;
      } else if (count > 2) {
        showed = false;
        count = 0;
      }

      if (connectivityResult != ConnectivityResult.wifi && !showed) {
        Get.snackbar("No WiFi...", "Please connect to a WiFi network.");
      }
    });

    passphraseFocus = FocusNode();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    connectivitySubscription.cancel();
    passphraseFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SpinningIconButton(
            controller: _animationController,
            iconData: Icons.sync,
            onPressed: () async {
              _animationController.repeat();
              _animationController.forward(from: _animationController.value);
              getNetworkInfo();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxHeight < 120) {
                      return const SizedBox(height: 25);
                    }

                    return UnDraw(
                      illustration: UnDrawIllustration.signal_searching,
                      color: Theme.of(context).colorScheme.secondary,
                    );
                  },
                ),
              ),
            ),
            const Flexible(child: SizedBox(height: 10)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "You are currently connected to:",
                style: Get.theme.textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SSID: ",
                    style: Get.theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    (wifiName ?? "Unable to get Wifi SSID")
                        .replaceAll(RegExp("\""), ""),
                    style: Get.theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "BSSID: ",
                    style: Get.theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    wifiBSSID ?? "Unable to get Wifi BSSID",
                    style: Get.theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const Flexible(child: SizedBox(height: 25)),
            Container(
              margin: const EdgeInsets.all(15),
              child: TextField(
                onTap: () => passphraseFocus.requestFocus(),
                onTapOutside: (_) => passphraseFocus.unfocus(),
                focusNode: passphraseFocus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: "Wifi Password:",
                  hintText: "Leave empty for open network.",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => passVisibility = !passVisibility);
                    },
                    icon: !passVisibility
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
                obscureText: passVisibility,
                onChanged: (value) => setState(() => passphrase = value),
              ),
            ),
            const Flexible(child: SizedBox(height: 25)),
            Container(
              margin: const EdgeInsets.all(15),
              child: FloatingActionButton(
                onPressed: () async {
                  if (wifiName == null || wifiBSSID == null) {
                    Get.snackbar(
                        "No WiFi...", "Please connect to a WiFi network.");
                    return;
                  }

                  String ssid = wifiName!.isNotEmpty
                      ? wifiName!.substring(1, wifiName!.length - 1)
                      : "";

                  final ESPTouchTask task = ESPTouchTask(
                    ssid: ssid,
                    bssid: wifiBSSID!,
                    password: passphrase ?? "",
                    packet: ESPTouchPacket.multicast,
                    taskParameter: const ESPTouchTaskParameter(
                      waitUdpSending: Duration(seconds: 45),
                      waitUdpReceiving: Duration(seconds: 45),
                    ),
                  );

                  bool isFinished = false;

                  final Stream<ESPTouchResult> stream = task.execute();
                  var sub = stream.listen((result) {
                    Navigator.of(context).pop();
                    if (result.bssid.isNotEmpty) {
                      isFinished = true;

                      Get.snackbar("Provisioning Success", result.bssid);
                    }
                  });

                  if (!mounted) {
                    return Future.value(null);
                  }
                  //
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text('Connecting device...'),
                              const SizedBox(height: 15),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  sub.cancel();
                                },
                                child: const Text("Cancel"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  await Future.any([
                    Future.doWhile(() async {
                      await Future.delayed(const Duration(seconds: 1));
                      return !isFinished;
                    }),
                    Future.delayed(const Duration(seconds: 90)),
                  ]);

                  if (!mounted) {
                    return Future.value(null);
                  }

                  if (!isFinished) {
                    Navigator.of(context).pop();
                    sub.cancel();

                    Get.snackbar("Provisioning Failure", "Oops!");
                  }
                },
                child: const Text(
                  "Connect",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getNetworkInfo() async {
    String? name, bssid;

    try {
      if (Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          name = await _networkInfo.getWifiName();
        } else {
          name = await _networkInfo.getWifiName();
        }
      } else {
        name = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (_) {
      name = null;
    }

    try {
      if (Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          bssid = await _networkInfo.getWifiBSSID();
        } else {
          bssid = await _networkInfo.getWifiBSSID();
        }
      } else {
        bssid = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (_) {
      bssid = null;
    }

    setState(
      () {
        wifiName = name;
        wifiBSSID = bssid;
      },
    );
  }
}
