import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nmock/button.dart';
import 'package:nmock/map.dart';
import 'package:nmock/styles.dart';

class SettingsData extends GetxController {
  Rx<bool> isClearingData = false.obs;

  Rx<bool> isSettingsVisible = false.obs;

  var retinaModeList = <String>['Auto', 'On', 'Off'].obs;
  Rx<String> retinaMode = "Auto".obs; // off, on, auto;
  toggle() {
    isSettingsVisible.value = !isSettingsVisible.value;
  }

  Rx<int> intervalSeconds = 1.obs;

  var intervalTextFieldDecoration = const InputDecoration(
    fillColor: Color.fromARGB(255, 55, 55, 100),
    filled: true,
    border: OutlineInputBorder(),
  ).obs;
  var intervalTextFieldController = TextEditingController(text: "1").obs;
}

SettingsData settingsData = SettingsData();

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.5,
          color: const Color.fromARGB(255, 255, 128, 0),
          child: Center(
              child: Text(
            "Route",
            style: styles.textStyle,
          )),
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Add Points: ", style: styles.textStyle),
                NButton(
                  onPressed: () {
                    mapData.toggleAddMode();
                  },
                  backgroundActiveColor: const Color.fromARGB(255, 255, 128, 0),
                  iconActiveColor: const Color.fromARGB(255, 255, 255, 255),
                  isChecked: mapData.addMode.value,
                  iconData: Icons.add,
                )
              ],
            ),
          ),
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Clear Map: ", style: styles.textStyle),
                NButton(
                  onPressed: () {
                    settingsData.isClearingData.value = true;
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        icon: const Icon(Icons.warning),
                        iconColor: const Color.fromARGB(255, 255, 128, 0),
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromARGB(255, 55, 55, 100))),
                        shadowColor: const Color.fromARGB(255, 55, 55, 100),
                        backgroundColor: const Color.fromARGB(192, 16, 16, 32),
                        contentTextStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        content: const Text(
                            'Are you sure you want to clear the map?'),
                        actions: <Widget>[
                          NButton(
                            onPressed: () async {
                              Navigator.pop(context, 'No');
                              settingsData.isClearingData.value = false;
                            },
                            isChecked: false,
                            iconData: Icons.clear,
                          ),
                          NButton(
                            onPressed: () {
                              Navigator.pop(context, 'Yes');
                              settingsData.isClearingData.value = false;
                              mapData.pins.clear();
                              mapData.pinsData.clear();
                              mapData.routes.clear();
                              mapData.redrawRoutes();
                              mapData.updateMap!();
                            },
                            isChecked: false,
                            iconData: Icons.check,
                          ),
                        ],
                      ),
                    );
                  },
                  backgroundActiveColor: const Color.fromARGB(255, 255, 128, 0),
                  iconActiveColor: const Color.fromARGB(255, 255, 255, 255),
                  isChecked: settingsData.isClearingData.value,
                  iconData: Icons.delete,
                )
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.5,
          color: const Color.fromARGB(255, 255, 128, 0),
          child: Center(
              child: Text(
            "Mock Location",
            style: styles.textStyle,
          )),
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Interval: ", style: styles.textStyle),
                SizedBox(
                  height: 40,
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    decoration: settingsData.intervalTextFieldDecoration.value,
                    controller: settingsData.intervalTextFieldController.value,
                    onSubmitted: (value) {
                      int? ival = int.tryParse(value);
                      if (ival != null) {
                        settingsData.intervalSeconds.value = ival;
                      }
                    },
                    onTapOutside: (pde) {
                      int? ival = int.tryParse(
                          settingsData.intervalTextFieldController.value.text);
                      if (ival != null) {
                        settingsData.intervalSeconds.value = ival;
                      }
                    },
                    onEditingComplete: () {
                      int? ival = int.tryParse(
                          settingsData.intervalTextFieldController.value.text);
                      if (ival != null) {
                        settingsData.intervalSeconds.value = ival;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.5,
          color: const Color.fromARGB(255, 255, 128, 0),
          child: Center(
              child: Text(
            "Map",
            style: styles.textStyle,
          )),
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Retina Mode: ", style: styles.textStyle),
                DropdownButton<String>(
                  value: settingsData.retinaMode.value,
                  icon: const Icon(
                    Icons.arrow_downward_sharp,
                    color: Color.fromARGB(255, 255, 128, 0),
                  ),
                  elevation: 16,
                  style: styles.orangeText,
                  underline: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 255, 128, 0),
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    settingsData.retinaMode.value = value!;
                    mapData.updateMap!();
                  },
                  items: settingsData.retinaModeList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: styles.orangeText,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.5,
          color: const Color.fromARGB(255, 55, 55, 100),
          child: Center(
              child: Text(
            "github.com/nirex0",
            style: styles.textStyle,
          )),
        ),
      ],
    );
  }
}

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(
              settingsData.isSettingsVisible.value
                  ? 0
                  : MediaQuery.of(context).size.width,
              0,
              0,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.5,
              color: const Color.fromARGB(192, 16, 16, 32),
              child: const SingleChildScrollView(child: SettingsContent()),
            ),
          ),
        ],
      ),
    );
  }
}
