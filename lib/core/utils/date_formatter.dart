import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', 'id_ID').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy - HH:mm', 'id_ID').format(date);
  }

  static String formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  static int calculateDaysDifference(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  static double calculateTotalPrice(
    double pricePerDay,
    int numberOfDays,
  ) {
    return pricePerDay * numberOfDays;
  }
}
