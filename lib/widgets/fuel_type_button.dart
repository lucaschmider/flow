import 'package:flow/models/fuel_type.dart';
import 'package:flutter/material.dart';

class FuelTypeButton extends StatelessWidget {
  final FuelType fuelType;
  final bool isSelected;
  final void Function() onSelected;

  const FuelTypeButton({
    super.key,
    required this.fuelType,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceVariant;

    final splashColor =
        Theme.of(context).colorScheme.surfaceTint.withAlpha(150);

    final textColor = isSelected
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: TweenAnimationBuilder(
        tween: ColorTween(
          begin: Theme.of(context).colorScheme.surface,
          end: backgroundColor,
        ),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) => Material(
          color: value,
          child: child,
        ),
        child: InkWell(
          onTap: onSelected,
          splashColor: splashColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fuelType.shortName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: textColor,
                    ),
              ),
              Text(
                fuelType.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
