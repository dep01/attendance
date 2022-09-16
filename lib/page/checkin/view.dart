import 'dart:convert';

import 'package:attendance/model/office_model.dart';
import 'package:attendance/static_routes.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:math';

import 'package:latlong2/latlong.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  List<OfficeModel> _listData = [];
  double lat = 0.0;
  double long = 0.0;
  var session = SessionManager();
  @override
  void initState() {
    loadData().then((value) {
      // if (value != '') {
      setState(() {
        _listData = officeModelFromMap(jsonEncode(value));
      });
      // }
    });
    super.initState();
  }

  Future<List<dynamic>> loadData() async {
    // print("aaa");
    dynamic jsonData = await session.get(Constants.storageOffice);
    // print(jsonData);
    if (jsonData == null) {
      return [];
    }
    return jsonData;
  }

  void handleCheckin(OfficeModel officeModel, context) {
    int r = 6371;
    double dLat = rad(officeModel.latitude! - lat);
    double dLong = rad(officeModel.longitude! - long);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(rad(officeModel.latitude!)) *
            cos(rad(lat)) *
            sin(dLong / 2) *
            sin(dLong / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double d = r * c * 1000;
    print(d);
    if (d > 50) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Warning'),
                content: const Text('Anda tidak berada disekitar lokasi'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    } else {
      showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Anda berhasil checkin'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.popUntil(
                        context, ModalRoute.withName(StaticRoutes.checkin)),
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
  }

  double rad(double deg) {
    return deg * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as LatLng;
    setState(() {
      lat = args.latitude;
      long = args.longitude;
    });
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _listData.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
                onPressed: () => handleCheckin(_listData[index], context),
                child: Text(_listData[index].name ?? ""));
          },
        ),
      ),
    ));
  }
}
