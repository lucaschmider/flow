import 'package:flutter/material.dart';

@immutable
class FuelType {
  final String id;
  final String description;
  final String shortName;

  const FuelType._({
    required this.id,
    required this.description,
    required this.shortName,
  });

  static const e5 = FuelType._(
    id: "b98c4caa-38a4-45d2-b4b6-867d7d4ba1e7",
    description: "Benzin",
    shortName: "E5",
  );

  static const e10 = FuelType._(
    id: "710724c9-5470-4508-a20f-30bb3b74886b",
    description: "Benzin E10",
    shortName: "E10",
  );

  static const diesel = FuelType._(
    id: "68ae2590-f7c3-4ab9-b176-1afe69c8c89d",
    description: "Diesel",
    shortName: "D",
  );

  static FuelType withId(String fuelTypeId) {
    if (fuelTypeId == e5.id) return e5;
    if (fuelTypeId == e10.id) return e10;
    if (fuelTypeId == diesel.id) return diesel;

    throw StateError("$fuelTypeId is not a known fuel type.");
  }
}
