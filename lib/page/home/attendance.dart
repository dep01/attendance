import 'dart:convert';

import 'package:attendance/model/office_model.dart';
import 'package:attendance/static_routes.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  LatLng _latLng = LatLng(-3.8659396, 117.2579618);
  List<OfficeModel> _listData = [];
  var session = SessionManager();
  final _mapController = MapController();
  Future<List<dynamic>> loadData() async {
    // print("aaa");
    dynamic jsonData = await session.get(Constants.storageOffice);
    // print(jsonData);
    if (jsonData == null) {
      return [];
    }
    return jsonData;
  }

  Future<Position> initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    initLocation().then((value) => {
          setState(() {
            _latLng = LatLng(value.latitude, value.longitude);
          }),
          gotoLocation()
        });
    loadData().then((value) {
      // if (value != '') {
      setState(() {
        _listData = officeModelFromMap(jsonEncode(value));
      });
      // }
    });
    super.initState();
  }

  void gotoLocation() {
    _mapController.move(_latLng, 17);
  }

  void doCheckIn(context) async {
    Navigator.pushNamed(context, StaticRoutes.checkin, arguments: _latLng);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(0),
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                center: _latLng, zoom: 9.2, onLongPress: (src, lat) {}),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
              MarkerLayerOptions(markers: [
                Marker(
                    point: _latLng,
                    builder: (_) {
                      return const SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.pin_drop),
                      );
                    }),
                for (var i = 0; i < _listData.length; i++)
                  Marker(
                      point: LatLng(
                          _listData[i].latitude!, _listData[i].longitude!),
                      builder: (_) {
                        return const SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.location_city_rounded),
                        );
                      }),
              ])
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: ElevatedButton(
              onPressed: () => doCheckIn(context),
              child: const Text("CHECK_IN")),
        )
      ],
    );
  }
}
