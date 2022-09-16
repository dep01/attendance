import 'package:attendance/static_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapOfficeScreen extends StatefulWidget {
  const MapOfficeScreen({Key? key}) : super(key: key);

  @override
  State<MapOfficeScreen> createState() => _MapOfficeScreenState();
}

class _MapOfficeScreenState extends State<MapOfficeScreen> {
  LatLng _latLng = LatLng(-3.8659396, 117.2579618);
  final _mapController = MapController();
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
    super.initState();
  }

  void gotoLocation() {
    _mapController.move(_latLng, 17);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(0),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
              center: _latLng,
              zoom: 9.2,
              onLongPress: (src, lat) {
                Navigator.pushNamed(context, StaticRoutes.addOffice,
                    arguments: LatLng(lat.latitude, lat.longitude));
              }),
          layers: [
            TileLayerOptions(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
          ],
        ),
      ),
    );
  }
}
