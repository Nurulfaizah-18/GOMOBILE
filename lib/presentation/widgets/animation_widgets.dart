import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Floating action bubble dengan menu
class FloatingActionBubble extends StatefulWidget {
  final List<BubbleAction> actions;
  final IconData icon;
  final Color backgroundColor;

  const FloatingActionBubble({
    Key? key,
    required this.actions,
    this.icon = Icons.add,
    this.backgroundColor = AppColors.electricBlue,
  }) : super(key: key);

  @override
  State<FloatingActionBubble> createState() => _FloatingActionBubbleState();
}

class BubbleAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  BubbleAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.electricBlue,
  });
}

class _FloatingActionBubbleState extends State<FloatingActionBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Menu items
        ScaleTransition(
          scale: _scaleAnimation,
          child: _buildMenuItems(),
        ),
        const SizedBox(height: 16),
        // Main FAB
        FloatingActionButton(
          onPressed: _toggleMenu,
          backgroundColor: widget.backgroundColor,
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Icon(widget.icon),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.actions.length,
        (index) {
          final action = widget.actions[index];
          return GestureDetector(
            onTap: () {
              action.onTap();
              _toggleMenu();
            },
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: action.color,
                    boxShadow: [
                      BoxShadow(
                        color: action.color.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(action.icon),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: action.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    action.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: action.color,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Gradient text widget
class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final TextStyle? style;

  const GradientText(
    this.text, {
    Key? key,
    required this.gradient,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: (style ?? const TextStyle(color: Colors.white)).copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Animated search bar dengan expandable effect
class AnimatedSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final String hintText;

  const AnimatedSearchBar({
    Key? key,
    required this.onChanged,
    required this.onTap,
    this.hintText = 'Cari kendaraan...',
  }) : super(key: key);

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late FocusNode _focusNode;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = TextEditingController();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _focusNode.addListener(_handleFocus);
  }

  void _handleFocus() {
    if (_focusNode.hasFocus) {
      _controller.forward();
      widget.onTap();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    _focusNode.dispose();
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? AppColors.electricBlue
                  : AppColors.borderColor,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: AppColors.electricBlue.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(
                Icons.search,
                color: AppColors.electricBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_textController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _textController.clear();
                    widget.onChanged('');
                  },
                  child: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              const SizedBox(width: 12),
            ],
          ),
        );
      },
    );
  }
}

/// Pulse loading indicator dengan multiple circles
class PulseLoadingWidget extends StatefulWidget {
  final Color color;
  final double size;

  const PulseLoadingWidget({
    Key? key,
    this.color = AppColors.electricBlue,
    this.size = 80,
  }) : super(key: key);

  @override
  State<PulseLoadingWidget> createState() => _PulseLoadingWidgetState();
}

class _PulseLoadingWidgetState extends State<PulseLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller2.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _controller3.forward();
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildPulse(_controller1, 1.0),
            _buildPulse(_controller2, 0.7),
            _buildPulse(_controller3, 0.4),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulse(AnimationController controller, double startSize) {
    return ScaleTransition(
      scale: Tween<double>(begin: startSize, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      ),
      child: Opacity(
        opacity: 1.0 - controller.value,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom tab bar dengan animated underline
class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final Function(int) onTabChanged;
  final int initialIndex;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.onTabChanged,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _tabController.addListener(() {
      widget.onTabChanged(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.electricBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        tabs: widget.tabs
            .map((tab) => Tab(
                  text: tab,
                ))
            .toList(),
      ),
    );
  }
}
