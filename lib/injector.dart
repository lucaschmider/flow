import 'package:flow/services/formatting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/refueling_bloc.dart';

class Injector extends StatelessWidget {
  final Widget child;
  const Injector({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FormattingService(),
      child: BlocProvider(
        create: (context) => RefuelingBloc(),
        child: child,
      ),
    );
  }
}
