import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;
  final EdgeInsets padding;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actionText,
    this.onActionPressed,
    this.actionIcon = Icons.arrow_forward,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionPressed,
              child: Row(
                children: [
                  Text(
                    actionText!,
                    style: const TextStyle(
                      color: AppColors.electricBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    actionIcon,
                    color: AppColors.electricBlue,
                    size: 16,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
