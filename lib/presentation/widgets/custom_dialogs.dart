import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final VoidCallback? onDismiss;
  final Widget? customContent;
  final Color? primaryButtonColor;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.onDismiss,
    this.customContent,
    this.primaryButtonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Message or Custom Content
            if (customContent != null)
              customContent!
            else
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (secondaryButtonText != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        onSecondaryPressed?.call();
                        Navigator.pop(context);
                        onDismiss?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          secondaryButtonText!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (primaryButtonText != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Pop dulu baru panggil callback untuk menghindari navigation error
                        Navigator.pop(context);
                        onPrimaryPressed?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          primaryButtonText!,
                          style: TextStyle(
                            color: primaryButtonColor ?? AppColors.electricBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Setuju',
    this.cancelText = 'Batal',
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      primaryButtonText: confirmText,
      secondaryButtonText: cancelText,
      primaryButtonColor: isDestructive ? Colors.red : AppColors.electricBlue,
      onPrimaryPressed: onConfirm,
      onSecondaryPressed: onCancel,
    );
  }
}

class BottomSheetModal extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final bool isDismissible;
  final VoidCallback? onDismiss;

  const BottomSheetModal({
    Key? key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.isDismissible = true,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.darkCard,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Content
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      builder: (context) => this,
    ).then((_) => onDismiss?.call());
  }
}

class FilterBottomSheet extends StatefulWidget {
  final Map<String, List<String>> filters;
  final Map<String, String>? selectedFilters;
  final VoidCallback? onApply;
  final VoidCallback? onReset;

  const FilterBottomSheet({
    Key? key,
    required this.filters,
    this.selectedFilters,
    this.onApply,
    this.onReset,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, String> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = Map.from(widget.selectedFilters ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetModal(
      title: 'Filter',
      isDismissible: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Filter options
          ...widget.filters.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: entry.value.map((option) {
                      final isSelected = _selectedFilters[entry.key] == option;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(option),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedFilters[entry.key] = option;
                            });
                          },
                          backgroundColor: AppColors.darkBackground,
                          selectedColor: AppColors.electricBlue,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.electricBlue
                                : AppColors.borderColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),

          // Action buttons
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _selectedFilters.clear());
                    widget.onReset?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderColor),
                  ),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply?.call();
                    Navigator.pop(context, _selectedFilters);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricBlue,
                  ),
                  child: const Text('Terapkan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SuccessDialog extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback? onDismiss;
  final Duration duration;

  const SuccessDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onDismiss,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        Navigator.pop(context);
        widget.onDismiss?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Message
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
