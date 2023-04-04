import 'package:flow/models/fuel_type.dart';

class Refueling {
  final String refuelingId;
  final DateTime timestamp;
  final double amount;
  final double totalPrice;
  final String fuelTypeId;
  final int mileage;
  FuelType get fuelType => FuelType.withId(fuelTypeId);

  Refueling({
    required this.refuelingId,
    required this.timestamp,
    required this.amount,
    required this.totalPrice,
    required this.fuelTypeId,
    required this.mileage,
  });

  Map<String, dynamic> toJson() {
    return {
      "refuelingId": refuelingId,
      "timestamp": timestamp.toString(),
      "amount": amount,
      "totalPrice": totalPrice,
      "fuelTypeId": fuelTypeId,
      "mileage": mileage,
    };
  }

  Refueling.fromJson(Map<String, dynamic> json)
      : this(
          amount: json["amount"],
          fuelTypeId: json["fuelTypeId"],
          refuelingId: json["refuelingId"],
          timestamp: DateTime.parse(json["timestamp"]),
          totalPrice: json["totalPrice"],
          mileage: json["mileage"],
        );
}
