// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:nmock/marker.dart';
import 'package:nmock/settings.dart';

class MapData extends GetxController {
  Rx<MapController> mapController = MapController().obs;
  late Function()? updateMap = () {};

  Rx<String> tilesetURL =
      'https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}'.obs;

  Rx<FMTCTileProvider> tileProvider =
      const FMTCStore('googleTilesMapStore').getTileProvider().obs;

  Rx<bool> addMode = false.obs;

  toggleAddMode() {
    addMode.value = !addMode.value;
  }

  var pins = <Marker>[].obs;
  var pinsData = <PinMarkerController>[].obs;
  var routes = <Polyline>[].obs;

  addPin(LatLng coords) {
    PinMarkerController ctrl = PinMarkerController();
    ctrl.lat.value = coords.latitude;
    ctrl.lng.value = coords.longitude;
    ctrl.text.value = "${mapData.pins.length + 1}";
    Marker marker = Marker(
      height: 100,
      width: 100,
      point: coords,
      child: PinMarker(controller: ctrl),
    );
    pins.add(marker);
    pinsData.add(ctrl);
    redrawRoutes();
    updateMap!();
  }

  redrawRoutes() {
    routes.value = [];
    for (var i = 0; i < pins.length - 1; i++) {
      Polyline tmppl1 = Polyline(
        points: [pins[i].point, pins[i + 1].point],
        color: const Color.fromARGB(255, 255, 128, 0),
        strokeWidth: 4.0,
      );
      Polyline tmppl2 = Polyline(
        points: [pins[i].point, pins[i + 1].point],
        color: const Color.fromARGB(255, 55, 55, 100),
        strokeWidth: 2.0,
      );
      routes.add(tmppl1);
      routes.add(tmppl2);
    }
    routes.refresh();
  }
}

Widget _darkModeTileBuilder(
  BuildContext context,
  Widget tileWidget,
  TileImage tile,
) {
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(<double>[
      -0.2126, -0.7152, -0.0722, 0.07, 245, // Red channel
      -0.2126, -0.7152, -0.0722, 0.07, 245, // Green channel
      -0.2126, -0.7152, -0.0722, 0.11, 255, // Blue channel
      0, 0, 0, 1, 0, // Alpha channel
    ]),
    child: tileWidget,
  );
}

MapData mapData = MapData();

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  updateState() {
    setState(() {});
  }

  @override
  void initState() {
    mapData.updateMap = updateState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var map = Obx(
      () => FlutterMap(
        mapController: mapData.mapController.value,
        options: MapOptions(
          initialCenter: const LatLng(35.7219, 51.3347),
          onTap: (tapPosition, point) {
            if (mapData.addMode.value) {
              mapData.addPin(point);
            }
          },
        ),
        children: [
          TileLayer(
            userAgentPackageName: 'com.nirex.nmock',
            urlTemplate: mapData.tilesetURL.value,
            tileProvider: mapData.tileProvider.value,
            retinaMode: settingsData.retinaMode.value == 'Auto'
                ? MediaQuery.of(context).devicePixelRatio > 1.0
                : settingsData.retinaMode.value == 'On'
                    ? true
                    : false,
            tileBuilder: _darkModeTileBuilder,
          ),
          PolylineLayer(
            polylines: mapData.routes,
          ),
          MarkerLayer(
            markers: mapData.pins,
            rotate: true,
          ),
        ],
      ),
    );

    return map;
  }
}
