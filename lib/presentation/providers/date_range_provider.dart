import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateRangeNotifier extends StateNotifier<DateRange> {
  DateRangeNotifier()
      : super(DateRange(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: 1)),
        ));

  void setDateRange(DateTime startDate, DateTime endDate) {
    state = DateRange(startDate: startDate, endDate: endDate);
  }

  void setStartDate(DateTime startDate) {
    state = DateRange(startDate: startDate, endDate: state.endDate);
  }

  void setEndDate(DateTime endDate) {
    state = DateRange(startDate: state.startDate, endDate: endDate);
  }

  int getDays() {
    return state.endDate.difference(state.startDate).inDays;
  }
}

class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  DateRange({required this.startDate, required this.endDate});
}

final dateRangeProvider =
    StateNotifierProvider<DateRangeNotifier, DateRange>((ref) {
  return DateRangeNotifier();
});

final rentalDaysProvider = Provider<int>((ref) {
  final dateRange = ref.watch(dateRangeProvider);
  return dateRange.endDate.difference(dateRange.startDate).inDays;
});
