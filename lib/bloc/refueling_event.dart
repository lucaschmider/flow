part of 'refueling_bloc.dart';

@immutable
abstract class RefuelingEvent {
  const RefuelingEvent();
}

@immutable
class RefuelingAdded extends RefuelingEvent {
  final double amount;
  final double totalPrice;
  final int mileage;
  final FuelType fuelType;

  const RefuelingAdded({
    required this.amount,
    required this.totalPrice,
    required this.fuelType,
    required this.mileage,
  });
}

@immutable
class RefuelingRemoved extends RefuelingEvent {
  final String refuelingId;

  const RefuelingRemoved({
    required this.refuelingId,
  });
}
