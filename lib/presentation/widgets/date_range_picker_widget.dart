import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';

/// Widget untuk pilih tanggal sewa - versi embedded (tampil di halaman)
class DateRangePickerWidget extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(DateTime, DateTime) onDateRangeSelected;

  const DateRangePickerWidget({
    Key? key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  State<DateRangePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.electricBlue,
              onPrimary: Colors.white,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.darkCard),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
        if (startDate.isAfter(endDate) || startDate.isAtSameMomentAs(endDate)) {
          endDate = startDate.add(const Duration(days: 1));
        }
      });
      widget.onDateRangeSelected(startDate, endDate);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.isAfter(startDate)
          ? endDate
          : startDate.add(const Duration(days: 1)),
      firstDate: startDate.add(const Duration(days: 1)),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.electricBlue,
              onPrimary: Colors.white,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.darkCard),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked.isAfter(startDate)) {
      setState(() => endDate = picked);
      widget.onDateRangeSelected(startDate, endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final days = endDate.difference(startDate).inDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.calendar_month, color: AppColors.electricBlue),
              const SizedBox(width: 12),
              Text(
                'Pilih Tanggal Sewa',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date Selection Row
          Row(
            children: [
              // Start Date
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _pickStartDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                AppColors.electricBlue.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.play_arrow,
                                  color: Colors.green, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Mulai',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            dateFormat.format(startDate),
                            style: TextStyle(
                              color: AppColors.electricBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Arrow
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, color: AppColors.electricBlue),
              ),

              // End Date
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _pickEndDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                AppColors.electricBlue.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.stop, color: Colors.red, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Sampai',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            dateFormat.format(endDate),
                            style: TextStyle(
                              color: AppColors.electricBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Duration Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.electricBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.electricBlue.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: AppColors.electricBlue, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Durasi: $days hari',
                  style: TextStyle(
                    color: AppColors.electricBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget untuk pilih tanggal sewa - versi Dialog
class CustomDateRangePickerDialog extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(DateTime, DateTime) onDateRangeSelected;

  const CustomDateRangePickerDialog({
    Key? key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  State<CustomDateRangePickerDialog> createState() =>
      _CustomDateRangePickerDialogState();
}

class _CustomDateRangePickerDialogState
    extends State<CustomDateRangePickerDialog> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.electricBlue,
              onPrimary: Colors.white,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.darkCard),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
        if (startDate.isAfter(endDate) || startDate.isAtSameMomentAs(endDate)) {
          endDate = startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.isAfter(startDate)
          ? endDate
          : startDate.add(const Duration(days: 1)),
      firstDate: startDate.add(const Duration(days: 1)),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.electricBlue,
              onPrimary: Colors.white,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.darkCard),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked.isAfter(startDate)) {
      setState(() => endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final days = endDate.difference(startDate).inDays;

    return Dialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.calendar_month, color: AppColors.electricBlue),
                const SizedBox(width: 12),
                Text(
                  'Pilih Tanggal Sewa',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date Selection Row
            Row(
              children: [
                // Start Date
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickStartDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.electricBlue
                                  .withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.play_arrow,
                                    color: Colors.green, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Mulai',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dateFormat.format(startDate),
                              style: TextStyle(
                                color: AppColors.electricBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap untuk ubah',
                              style: TextStyle(
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.7),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Arrow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child:
                      Icon(Icons.arrow_forward, color: AppColors.electricBlue),
                ),

                // End Date
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _pickEndDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.electricBlue
                                  .withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.stop, color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Sampai',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dateFormat.format(endDate),
                              style: TextStyle(
                                color: AppColors.electricBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap untuk ubah',
                              style: TextStyle(
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.7),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Duration Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.electricBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.electricBlue.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer, color: AppColors.electricBlue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Durasi: $days hari',
                    style: TextStyle(
                      color: AppColors.electricBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: AppColors.borderColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context, {'start': startDate, 'end': endDate});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Konfirmasi'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
