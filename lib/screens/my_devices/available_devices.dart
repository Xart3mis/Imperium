import 'dart:async';

import 'dart:typed_data';

import 'package:ms_undraw/ms_undraw.dart';
import 'package:smart_rgb/screens/my_devices/device_card.dart';
import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

// ignore_for_file: avoid_print

class AvailableDevices extends StatefulWidget {
  const AvailableDevices({super.key});

  @override
  State<AvailableDevices> createState() => _AvailableDevicesState();
}

class _AvailableDevicesState extends State<AvailableDevices> {
  late StreamSubscription connectivitySubscription;
  Discovery? discovery;
  String type = "_http._tcp";

  @override
  initState() {
    super.initState();

    enableLogging(LogTopic.errors);
    enableLogging(LogTopic.calls);

    bool showed = false;
    int count = 0;
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
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

    beginDiscovery().then(
        (_) => discovery!.addListener(() => updateIfMounted(() => discovery)));
  }

  void updateIfMounted(dynamic Function() callback) {
    if (!mounted) {
      return;
    }

    setState(callback);
  }

  @override
  dispose() {
    super.dispose();
    connectivitySubscription.cancel();
    discovery?.dispose();
  }

  Future<void> beginDiscovery() async {
    discovery = await startDiscovery(type, ipLookupType: IpLookupType.v4);
    updateIfMounted(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (discovery == null) {
      return Container();
    }

    return RefreshIndicator(
      child: discovery!.services.isEmpty
          ? UnDraw(
              illustration: UnDrawIllustration.not_found,
              color: Get.theme.colorScheme.secondary,
            )
          : ListView.builder(
              itemCount: discovery!.services.length,
              itemBuilder: (context, idx) {
                if (discovery!.services[idx].txt == null) {
                  return null;
                }

                Uint8List? idCharCodes = discovery!.services[idx].txt!["ID"];
                String id = String.fromCharCodes(idCharCodes ?? []);

                if (id != "ImperiumNode") {
                  return null;
                }

                Uint8List? productCharCodes =
                    discovery!.services[idx].txt!["Product"];
                String product = String.fromCharCodes(productCharCodes ?? []);

                Uint8List? macCharCodes = discovery!.services[idx].txt!["MAC"];
                String mac = String.fromCharCodes(macCharCodes ?? []);

                return DeviceCard(
                  deviceName: product.isEmpty ? "Unknown" : product,
                  deviceInfo: mac.isEmpty ? "Unknown" : mac,
                  deviceAddress: discovery!.services[idx].host ?? "0.0.0.0",
                );
              },
            ),
      onRefresh: () async {
        List<Service> services = discovery!.services;
        await stopDiscovery(discovery!);
        await beginDiscovery();
        for (var service in services) {
          discovery!.add(service);
        }
        discovery!.addListener(() => updateIfMounted(() => discovery));
      },
    );
  }
}
