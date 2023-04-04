import 'package:collection/collection.dart';
import 'package:flow/bloc/refueling_bloc.dart';
import 'package:flow/models/fuel_type.dart';
import 'package:flow/pages/add_refueling_page.dart';
import 'package:flow/services/formatting_service.dart';
import 'package:flow/utils/date_extensions.dart';
import 'package:flow/utils/iterable_extensions.dart';
import 'package:flow/widgets/stat_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefuelingList extends StatelessWidget {
  const RefuelingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattingService = context.read<FormattingService>();
    return BlocBuilder<RefuelingBloc, RefuelingState>(
        builder: (context, state) {
      final groupedByMonth = groupBy(
        state.refuelings,
        (r) => r.timestamp.firstOfMonth(),
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text("Flow"),
          actions: [
            IconButton(
              onPressed: () => pushAddRefuelingPage(
                context,
                state.defaultFuelType,
                state.lastMileage,
              ),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            if (state is RefuelingReady) {
              final totalExpenses =
                  state.refuelings.sumBy((item) => item.totalPrice);
              final totalVolume = state.refuelings.sumBy((item) => item.amount);

              final monthlyExpenses = totalExpenses / groupedByMonth.length;
              final monthlyVolume = totalVolume / groupedByMonth.length;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid.count(
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      children: [
                        StatPanel(
                          description: "im Monat",
                          value:
                              formattingService.formatCurrency(monthlyExpenses),
                        ),
                        StatPanel(
                          description: "im Monat",
                          value: formattingService.formatVolume(monthlyVolume),
                        ),
                      ],
                    ),
                  ),
                  ...groupedByMonth.entries
                      .sortedBy((element) => element.key)
                      .reversed
                      .expand((element) {
                    final sortedRefuelings = element.value
                        .sortedBy((element) => element.timestamp)
                        .reversed;
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ListTile(
                            title: Text(
                              formattingService.formatMonth(element.key),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            trailing: Badge(
                              label: Text(formattingService.formatCurrency(
                                  sortedRefuelings
                                      .sumBy((item) => item.totalPrice))),
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final refueling = sortedRefuelings.elementAt(index);
                            return Dismissible(
                              key: Key(refueling.refuelingId),
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.delete_forever,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onError,
                                        ),
                                        Text(
                                          "Löschen",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onError),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) => context
                                  .read<RefuelingBloc>()
                                  .add(RefuelingRemoved(
                                    refuelingId: refueling.refuelingId,
                                  )),
                              child: ListTile(
                                subtitle: Text(
                                    "am ${formattingService.formatDate(refueling.timestamp)}"),
                                title: Text(
                                    "${formattingService.formatVolume(refueling.amount)} ${refueling.fuelType.description}"),
                                trailing: Text(formattingService
                                    .formatCurrency(refueling.totalPrice)),
                              ),
                            );
                          },
                          childCount: element.value.length,
                        ),
                      ),
                    ];
                  })
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hourglass_empty),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Du hast noch nie mit uns getankt.",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text(
                      "Beginne damit, deinen ersten Tankvorgang in der App zu speichern",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => pushAddRefuelingPage(
                        context,
                        state.defaultFuelType,
                        state.lastMileage,
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text("Ersten Tankvorgang speichern"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void pushAddRefuelingPage(
      BuildContext context, FuelType defaultFuelType, int currentMileage) {
    Navigator.push<RefuelingAdded>(
      context,
      MaterialPageRoute(
        builder: (context) => AddRefuelingPage(
          defaultFuelType: defaultFuelType,
          currentMileage: currentMileage,
        ),
      ),
    ).then((value) {
      if (value != null) context.read<RefuelingBloc>().add(value);
    });
  }
}
