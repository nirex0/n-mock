import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_isolate/flutter_isolate.dart';

import 'package:flutter/material.dart';
import 'package:fluttermocklocation/fluttermocklocation.dart';
import 'package:get/get.dart';
import 'package:nmock/button.dart';
import 'package:nmock/map.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:nmock/settings.dart';
import 'package:nmock/styles.dart';

@pragma('vm:entry-point')
void _isolateFunction(String arg) {
  while (true) {
    sleep(const Duration(seconds: 1));
  }
}

_timerFunction() {
  if (mapData.pinsData.isNotEmpty) {
    if (iter < mapData.pinsData.length) {
      var lat = mapData.pinsData[iter].lat.value;
      var lng = mapData.pinsData[iter].lng.value;
      Fluttermocklocation().updateMockLocation(lat, lng);
      iter++;
    } else {
      iter = 0;
    }
  }
}

late Timer globalTimer;
var currentInterval = 0;
var iter = 0;

Future<void> main() async {
  // Ensure Widget Initialization
  WidgetsFlutterBinding.ensureInitialized();

  globalTimer = Timer.periodic(
      Duration(seconds: settingsData.intervalSeconds.value), (timer) {
    _timerFunction();
  });

  // Run app in Background
  const androidConfig = FlutterBackgroundAndroidConfig();
  await FlutterBackground.initialize(androidConfig: androidConfig);
  await FlutterBackground.enableBackgroundExecution();
  FlutterIsolate.spawn(_isolateFunction, '');

  // Initialize Map Caching ObjectBox Database
  await FMTCObjectBoxBackend().initialise();
  await const FMTCStore('googleTilesMapStore').manage.create();

  // Run the App
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N-MOCK',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 25),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'N-Mock',
                style: styles.headerTextStyle,
              ),
              Obx(
                () => NButton(
                  onPressed: () {
                    settingsData.toggle();
                  },
                  isChecked: settingsData.isSettingsVisible.value,
                  iconData: Icons.settings,
                ),
              ),
            ],
          ),
        ),
        body: const Stack(
          children: [
            MapPage(),
            SettingsPanel(),
          ],
        ),
      ),
    );
  }
}
