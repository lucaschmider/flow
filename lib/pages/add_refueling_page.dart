import 'package:flow/models/fuel_type.dart';
import 'package:flow/widgets/fuel_type_button.dart';
import 'package:flutter/material.dart';
import '../bloc/refueling_bloc.dart';

class AddRefuelingPage extends StatefulWidget {
  final FuelType defaultFuelType;
  final int currentMileage;
  const AddRefuelingPage({
    super.key,
    required this.defaultFuelType,
    required this.currentMileage,
  });

  @override
  State<AddRefuelingPage> createState() => _AddRefuelingPageState();
}

class _AddRefuelingPageState extends State<AddRefuelingPage> {
  late FuelType fuelType;
  final amountController = TextEditingController();
  final totalPriceController = TextEditingController();
  final mileageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fuelType = widget.defaultFuelType;
    super.initState();
  }

  void saveRefueling(BuildContext context) {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Wir konnten deinen Vorgang nicht speichern, bitte prüfe deine Eingaben.")));
      return;
    }
    final amountDouble =
        double.parse(amountController.text.replaceAll(",", "."));
    final totalPriceDouble =
        double.parse(totalPriceController.text.replaceAll(",", "."));
    final mileage = int.parse(mileageController.text);

    Navigator.of(context).pop(RefuelingAdded(
      amount: amountDouble,
      totalPrice: totalPriceDouble,
      fuelType: fuelType,
      mileage: mileage,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tankvorgang speichern"),
        actions: [
          IconButton(
            onPressed: _formKey.currentState?.validate() ?? false
                ? () => saveRefueling(context)
                : null,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              "Was hast du getankt?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16.0,
              padding: const EdgeInsets.only(),
              children: [FuelType.e5, FuelType.e10, FuelType.diesel]
                  .map(
                    (e) => FuelTypeButton(
                      fuelType: e,
                      isSelected: e == fuelType,
                      onSelected: () => setState(() {
                        fuelType = e;
                      }),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              "Wie viel hast du getankt?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: amountController,
              textAlign: TextAlign.right,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                filled: true,
                label: Text("Menge"),
                suffixText: "Liter",
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bitte gib die Menge an, die du getankt hast";
                }

                if (double.tryParse(value.replaceAll(",", ".")) == null) {
                  return "Bitte gib eine gültige Zahl ein";
                }

                return null;
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              "Wie viel hast du bezahlt?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: totalPriceController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                filled: true,
                label: Text("Preis"),
                suffixText: "€",
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bitte gib den Preis an, den du gezahlt hast";
                }

                if (double.tryParse(value.replaceAll(",", ".")) == null) {
                  return "Bitte gib eine gültige Zahl ein";
                }

                return null;
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              "Was ist dein Kilometerstand?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: mileageController,
              textAlign: TextAlign.right,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                filled: true,
                label: Text("Kilometerstand"),
                suffixText: "Kilometer",
              ),
              keyboardType: const TextInputType.numberWithOptions(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Bitte gib deinen aktuellen Kilometerstand an.";
                }

                final parsedValue = int.tryParse(value);
                if (parsedValue == null) {
                  return "Bitte gib eine gültige Zahl ein";
                }

                if (parsedValue <= widget.currentMileage) {
                  return "Der Kilometerstand beim letzten Tanken war höher.";
                }

                return null;
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextButton.icon(
              onPressed: _formKey.currentState?.validate() ?? false
                  ? () => saveRefueling(context)
                  : null,
              icon: const Icon(Icons.check),
              label: const Text("Vorgang speichern"),
            ),
          ],
        ),
      ),
    );
  }
}
