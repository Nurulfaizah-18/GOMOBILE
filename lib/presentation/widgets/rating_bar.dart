import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final int itemCount;
  final Color itemColor;
  final Color unratedColor;
  final double itemSize;
  final MainAxisAlignment mainAxisAlignment;
  final bool showValue;

  const RatingBar({
    Key? key,
    required this.rating,
    this.itemCount = 5,
    this.itemColor = Colors.amber,
    this.unratedColor = AppColors.borderColor,
    this.itemSize = 16,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.showValue = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        ...List.generate(itemCount, (index) {
          final isFilled = index < rating.ceil();
          final isHalfFilled = index < rating && !isFilled;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background star (unrated)
                Icon(
                  Icons.star,
                  size: itemSize,
                  color: unratedColor,
                ),
                // Foreground star (rated)
                if (isFilled || isHalfFilled)
                  ClipRect(
                    clipper: _HalfClipper(
                      isHalf: isHalfFilled,
                      isRTL: false,
                    ),
                    child: Icon(
                      Icons.star,
                      size: itemSize,
                      color: itemColor,
                    ),
                  ),
              ],
            ),
          );
        }),
        if (showValue) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  final bool isHalf;
  final bool isRTL;

  _HalfClipper({
    required this.isHalf,
    required this.isRTL,
  });

  @override
  Rect getClip(Size size) {
    if (!isHalf) {
      return Rect.fromLTWH(0, 0, size.width, size.height);
    }
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(_HalfClipper oldClipper) {
    return isHalf != oldClipper.isHalf;
  }
}

class InteractiveRatingBar extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;
  final int itemCount;
  final Color itemColor;
  final double itemSize;

  const InteractiveRatingBar({
    Key? key,
    required this.initialRating,
    required this.onRatingChanged,
    this.itemCount = 5,
    this.itemColor = Colors.amber,
    this.itemSize = 32,
  }) : super(key: key);

  @override
  State<InteractiveRatingBar> createState() => _InteractiveRatingBarState();
}

class _InteractiveRatingBarState extends State<InteractiveRatingBar> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.itemCount, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = (index + 1).toDouble();
            });
            widget.onRatingChanged(_currentRating);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.star,
              size: widget.itemSize,
              color: index < _currentRating
                  ? widget.itemColor
                  : AppColors.borderColor,
            ),
          ),
        );
      }),
    );
  }
}
