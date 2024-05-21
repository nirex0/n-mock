import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttermocklocation/fluttermocklocation.dart';
import 'package:get/get.dart';
import 'package:nmock/button.dart';
import 'package:nmock/map.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:nmock/notification_service.dart';
import 'package:nmock/settings.dart';
import 'package:nmock/styles.dart';

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

_initBackgroundPermissions() async {
  notifyService = NotificationService();

  // Run app in Background
  const androidConfig = FlutterBackgroundAndroidConfig();
  await FlutterBackground.initialize(androidConfig: androidConfig);
  await FlutterBackground.enableBackgroundExecution();
}

_initNotificatonPermissions() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '1200', 'n-mock',
      ongoing: true,
      autoCancel: false,
      channelDescription: 'N-Mock Running',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false);

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
      0,
      'N-Mock',
      'N-Mock Fake Location Running in the background',
      platformChannelSpecifics,
      payload: 'item x');
}

late NotificationService notifyService;
late Timer globalTimer;
var iter = 0;

Future<void> main() async {
  // Ensure Widget Initialization
  WidgetsFlutterBinding.ensureInitialized();

  Timer(const Duration(seconds: 3), () {
    _initBackgroundPermissions();
  });
  Timer(const Duration(seconds: 3), () {
    _initNotificatonPermissions();
  });

  // Initialize Map Caching ObjectBox Database
  await FMTCObjectBoxBackend().initialise();
  await const FMTCStore('googleTilesMapStore').manage.create();

  globalTimer = Timer.periodic(
      Duration(seconds: settingsData.intervalSeconds.value), (timer) {
    _timerFunction();
  });
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
