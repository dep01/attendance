import 'dart:convert';

import 'package:attendance/model/office_model.dart';
import 'package:attendance/static_routes.dart';
import 'package:attendance/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class OfficeScreen extends StatefulWidget {
  const OfficeScreen({Key? key}) : super(key: key);

  @override
  State<OfficeScreen> createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
  List<OfficeModel> _listData = [];
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

  Future goToAddPage(context) async {
    await Navigator.pushNamed(context, StaticRoutes.mapOffice)
        .then((value) => initState());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: _listData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_listData[index].name ?? ""),
                );
              },
            ),
          ),
          Positioned(
              bottom: 5,
              right: 5,
              child: ElevatedButton(
                child: const Text("ADD OFFICE"),
                onPressed: () => goToAddPage(context),
              ))
        ],
      ),
    );
  }
}
