import 'package:flutter/material.dart';
import 'dart:io';
import '../../core/theme/app_colors.dart';

/// Helper widget untuk menampilkan gambar dari URL atau path lokal
class VehicleImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const VehicleImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  bool get _isLocalFile {
    return imageUrl.startsWith('/') ||
        imageUrl.startsWith('file://') ||
        imageUrl.contains('cache') ||
        imageUrl.contains('data/');
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_isLocalFile) {
      // Gambar lokal dari device
      final file = File(imageUrl.replaceFirst('file://', ''));
      if (file.existsSync()) {
        imageWidget = Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        );
      } else {
        imageWidget = _buildPlaceholder();
      }
    } else if (imageUrl.startsWith('http')) {
      // Gambar dari URL
      imageWidget = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: const AlwaysStoppedAnimation(AppColors.electricBlue),
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      imageWidget = _buildPlaceholder();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.darkSurface,
      child: const Center(
        child: Icon(
          Icons.directions_car,
          size: 50,
          color: AppColors.electricBlue,
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String brand;
  final double rating;
  final int reviewCount;
  final double pricePerDay;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VehicleCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.brand,
    required this.rating,
    required this.reviewCount,
    required this.pricePerDay,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: (onEdit != null || onDelete != null)
          ? () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  color: AppColors.darkCard,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          onTap: () {
                            Navigator.pop(context);
                            onEdit!();
                          },
                        ),
                      if (onDelete != null)
                        ListTile(
                          leading:
                              const Icon(Icons.delete, color: AppColors.error),
                          title: const Text('Delete',
                              style: TextStyle(color: AppColors.error)),
                          onTap: () {
                            Navigator.pop(context);
                            _showDeleteConfirmation(context);
                          },
                        ),
                    ],
                  ),
                ),
              );
            }
          : null,
      child: Card(
        color: AppColors.darkCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    color: AppColors.darkSurface,
                  ),
                  child: VehicleImage(
                    imageUrl: imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? AppColors.error
                            : AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Brand
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    brand,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '$rating',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviewCount)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    'Rp ${pricePerDay.toStringAsFixed(0)}/hari',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.electricBlue,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: const Text('Hapus Kendaraan'),
        content: const Text('Apakah Anda yakin ingin menghapus kendaraan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete!();
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
