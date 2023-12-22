import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final VoidCallback? onEnd;
  final bool isSmallIcon;
  const LikeAnimation({super.key, required this.child, required this.isAnimating, this.onEnd, this.isSmallIcon = false});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.isSmallIcon ? 100 : 500));
    _animation = Tween<double>(begin: 1, end: 1.2).animate(_controller);
    super.initState();
  }
  
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    if (widget.isAnimating != oldWidget.isAnimating && (widget.isAnimating || widget.isSmallIcon)) {
      startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  startAnimation() async {
    await _controller.forward();
    await _controller.reverse();
    if (widget.onEnd != null) {
      Future.delayed(const Duration(milliseconds: 200));
      widget.onEnd!();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}