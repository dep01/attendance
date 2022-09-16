// To parse this JSON data, do
//
//     final officeModel = officeModelFromMap(jsonString);

import 'dart:convert';

List<OfficeModel> officeModelFromMap(String str) =>
    List<OfficeModel>.from(json.decode(str).map((x) => OfficeModel.fromMap(x)));

String officeModelToMap(List<OfficeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class OfficeModel {
  OfficeModel({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
  });

  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;

  OfficeModel copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
  }) =>
      OfficeModel(
        id: id ?? this.id,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory OfficeModel.fromMap(Map<String, dynamic> json) => OfficeModel(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
      };
}
