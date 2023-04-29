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

  String formatInDays(DateTime date) {
    DateTime now = DateTime.now();
    DateTime date1 = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime date2 = DateTime(date.year, date.month, date.day, 0, 0, 0);

    Duration difference = date2.difference(date1);

    if (difference.inDays == 0) {
      return "Hoje";
    }

    if (difference.inDays == -1) {
      return "Ontem";
    }

    if (difference.inDays == 1) {
      return "Amanhã";
    }

    return DateFormat("dd/MM/yyyy").format(date).toString();
  }
}
