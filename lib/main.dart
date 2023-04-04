import 'package:flow/injector.dart';
import 'package:flow/pages/refueling_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory());
  await initializeDateFormatting("de_DE", null);
  Intl.defaultLocale = "de_DE";
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  ThemeData _buildTheme() {
    var baseTheme = ThemeData.dark(
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.aBeeZeeTextTheme(baseTheme.textTheme),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFADC6FF),
        onPrimary: Color(0xFF002E69),
        primaryContainer: Color(0xFF004494),
        onPrimaryContainer: Color(0xFFD8E2FF),
        secondary: Color(0xFFBFC6DC),
        onSecondary: Color(0xFF293041),
        secondaryContainer: Color(0xFF3F4759),
        onSecondaryContainer: Color(0xFFDBE2F9),
        tertiary: Color(0xFFDEBCDF),
        onTertiary: Color(0xFF402843),
        tertiaryContainer: Color(0xFF583E5B),
        onTertiaryContainer: Color(0xFFFBD7FC),
        error: Color(0xFFFFB4AB),
        errorContainer: Color(0xFF93000A),
        onError: Color(0xFF690005),
        onErrorContainer: Color(0xFFFFDAD6),
        background: Color(0xFF1B1B1F),
        onBackground: Color(0xFFE3E2E6),
        outline: Color(0xFF8E9099),
        onInverseSurface: Color(0xFF1B1B1F),
        inverseSurface: Color(0xFFE3E2E6),
        inversePrimary: Color(0xFF005BC1),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFFADC6FF),
        outlineVariant: Color(0xFF44474F),
        scrim: Color(0xFF000000),
        surface: Color(0xFF121316),
        onSurface: Color(0xFFC7C6CA),
        surfaceVariant: Color(0xFF44474F),
        onSurfaceVariant: Color(0xFFC4C6D0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Injector(
      child: MaterialApp(
        theme: _buildTheme(),
        home: const Injector(
          child: RefuelingList(),
        ),
      ),
    );
  }
}
