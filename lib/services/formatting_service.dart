import 'package:intl/intl.dart';

class FormattingService {
  static final _monthFormatter = DateFormat("MMMM");
  static final _monthWithYearFormatter = DateFormat("MMMM y");
  static final _dateFormatter = DateFormat("EEEE, d. MMMM y");
  static final _currencyFormatter = NumberFormat.simpleCurrency();
  static final _decimalFormatter = NumberFormat.decimalPattern();

  String formatCurrency(num amount) => _currencyFormatter.format(amount);
  String formatVolume(num volume) => "${_decimalFormatter.format(volume)}l";
  String formatMonth(DateTime date) => DateTime.now().year == date.year
      ? _monthFormatter.format(date)
      : _monthWithYearFormatter.format(date);
  String formatDate(DateTime date) => _dateFormatter.format(date);
}
