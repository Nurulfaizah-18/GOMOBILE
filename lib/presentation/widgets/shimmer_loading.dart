import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ShimmerLoadingCard extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const ShimmerLoadingCard({
    Key? key,
    this.height = 200,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<ShimmerLoadingCard> createState() => _ShimmerLoadingCardState();
}

class _ShimmerLoadingCardState extends State<ShimmerLoadingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
              colors: [
                AppColors.darkCard,
                AppColors.darkCard.withValues(alpha: 0.6),
                AppColors.darkCard,
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerLoadingGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const ShimmerLoadingGrid({
    Key? key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerLoadingCard(
          height: 250,
          borderRadius: BorderRadius.circular(16),
        );
      },
    );
  }
}
