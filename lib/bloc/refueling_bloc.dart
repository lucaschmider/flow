import 'package:flow/models/fuel_type.dart';
import 'package:flow/models/refueling.dart';
import 'package:flow/utils/iterable_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:uuid/uuid.dart';

part 'refueling_event.dart';
part 'refueling_state.dart';

class RefuelingBloc extends HydratedBloc<RefuelingEvent, RefuelingState> {
  static const _uuid = Uuid();

  RefuelingBloc() : super(RefuelingInitial()) {
    on<RefuelingAdded>(_handleAddRefueling);
    on<RefuelingRemoved>(_handleRemoveRefueling);
  }

  void _handleAddRefueling(
    RefuelingAdded event,
    Emitter<RefuelingState> emit,
  ) {
    final newRefueling = Refueling(
      refuelingId: _uuid.v4(),
      timestamp: DateTime.now(),
      amount: event.amount,
      totalPrice: event.totalPrice,
      fuelTypeId: event.fuelType.id,
      mileage: event.mileage,
    );

    emit(RefuelingReady(
      lastMileage: event.mileage,
      defaultFuelType: event.fuelType,
      refuelings: [
        ...state.refuelings,
        newRefueling,
      ],
    ));
  }

  void _handleRemoveRefueling(
    RefuelingRemoved event,
    Emitter<RefuelingState> emit,
  ) {
    final newRefuelings = state.refuelings
        .where((element) => element.refuelingId != event.refuelingId)
        .toList();

    final newState = newRefuelings.isEmpty
        ? RefuelingInitial(
            defaultFuelType: state.defaultFuelType,
          )
        : RefuelingReady(
            lastMileage:
                newRefuelings.maxBy<num>((item) => item.mileage).mileage,
            defaultFuelType: state.defaultFuelType,
            refuelings: newRefuelings,
          );

    emit(newState);
  }

  @override
  RefuelingState? fromJson(Map<String, dynamic> json) {
    return RefuelingState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(RefuelingState state) {
    return state.toJson();
  }
}
