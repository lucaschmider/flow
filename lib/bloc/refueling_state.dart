part of 'refueling_bloc.dart';

@immutable
abstract class RefuelingState {
  final int lastMileage;
  final FuelType defaultFuelType;
  final List<Refueling> refuelings;
  String get typeName;

  Map<String, dynamic> toJson() {
    return {
      "__RUNTIME_TYPE": typeName,
      "defaultFuelType": defaultFuelType.id,
      "refuelings": refuelings.map((e) => e.toJson()).toList()
    };
  }

  static RefuelingState? fromJson(Map<String, dynamic> json) {
    final runtimeType = json["__RUNTIME_TYPE"] as String;
    final defaultFuelType = FuelType.withId(json["defaultFuelType"]);
    final refuelings = (json["refuelings"] as List<dynamic>)
        .map((e) => Refueling.fromJson(e))
        .toList();
    if (runtimeType == "RefuelingReady") {
      return RefuelingReady(
        lastMileage: refuelings.maxBy<num>((item) => item.mileage).mileage,
        defaultFuelType: defaultFuelType,
        refuelings: refuelings,
      );
    }

    if (runtimeType == "RefuelingInitial") {
      return RefuelingInitial();
    }

    return null;
  }

  const RefuelingState({
    required this.defaultFuelType,
    required this.refuelings,
    required this.lastMileage,
  });
}

@immutable
class RefuelingInitial extends RefuelingState {
  RefuelingInitial({
    super.defaultFuelType = FuelType.e5,
    super.lastMileage = 0,
  }) : super(refuelings: []);

  @override
  String get typeName => "RefuelingInitial";
}

@immutable
class RefuelingReady extends RefuelingState {
  const RefuelingReady({
    required super.defaultFuelType,
    required super.refuelings,
    required super.lastMileage,
  });

  @override
  String get typeName => "RefuelingReady";
}
