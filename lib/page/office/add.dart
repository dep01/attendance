import 'dart:convert';

import 'package:attendance/model/office_model.dart';
import 'package:attendance/static_routes.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:latlong2/latlong.dart';

class AddOfficeScreen extends StatefulWidget {
  const AddOfficeScreen({Key? key}) : super(key: key);

  @override
  State<AddOfficeScreen> createState() => _AddOfficeScreenState();
}

class _AddOfficeScreenState extends State<AddOfficeScreen> {
  List<OfficeModel> _listData = [];
  String name = "";
  double lat = 0;
  double long = 0;
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
    if (jsonData == null) {
      return [];
    }
    return jsonData;
  }

  void handleSave(context) async {
    if (name != "") {
      final id =
          _listData.isEmpty ? 1 : _listData[_listData.length - 1].id! + 1;
      final data = OfficeModel.fromMap(
          {"id": id, "name": name, "latitude": lat, "longitude": long});
      _listData.add(data);
      // _listData.map((e) => {e.toMap(), print(e)});
      List pushData = [];
      for (var i = 0; i < _listData.length; i++) {
        pushData.add(_listData[i].toMap());
      }
      // print(pushData.toSt?ring());
      // print(json.encode(pushData));
      await session.remove(Constants.storageOffice);
      session.set(Constants.storageOffice, jsonEncode(pushData));
      Navigator.popUntil(context, ModalRoute.withName(StaticRoutes.home));
    }
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
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) => setState(() {
                  name = value;
                }),
              ),
              ElevatedButton(
                  onPressed: () => handleSave(context),
                  child: const Text("SAVE"))
            ],
          ),
        ),
      ),
    );
  }
}
