import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  Future<String> format(
      {required String locale,
      required String format,
      required DateTime dateTime}) async {
    await initializeDateFormatting(locale, null);

    return DateFormat(format, locale).format(dateTime);
  }
}
