import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final String? userName;
  final VoidCallback? onSearchTap;

  const DashboardHeader({
    Key? key,
    this.userName = 'User',
    this.onSearchTap,
  }) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 17) {
      return 'Selamat Siang';
    } else if (hour < 19) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkCard,
            AppColors.darkCard.withValues(alpha: 0.5),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName ?? 'User',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.electricBlue.withValues(alpha: 0.8),
                      AppColors.electricBlue.withValues(alpha: 0.4),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.darkBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Cari kendaraan...',
                        hintStyle:
                            const TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.electricBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.tune,
                          color: AppColors.electricBlue,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
