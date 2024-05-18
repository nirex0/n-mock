import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinMarkerController extends GetxController {
  var text = "".obs;
  var waypointColor = const Color.fromARGB(255, 255, 128, 0).obs;
  var textColor = const Color(0xFFFFFFFF).obs;
  var waypointIcon = FontAwesomeIcons.mapPin.obs;

  var lat = 0.0.obs;
  var lng = 0.0.obs;
}

class PinMarker extends StatelessWidget {
  final PinMarkerController controller;
  const PinMarker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(2)),
              child: Icon(
                controller.waypointIcon.value,
                color: controller.waypointColor.value,
                size: 24,
              ),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 1, 0, 0)),
            Container(
              width: 20,
              decoration: BoxDecoration(
                  color: controller.waypointColor.value,
                  borderRadius: BorderRadius.circular(2)),
              child: Center(
                child: Text(
                  controller.text.value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: controller.textColor.value),
                ),
              ),
            ),
            // const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 43)),
          ],
        ),
      ),
    );
  }
}
