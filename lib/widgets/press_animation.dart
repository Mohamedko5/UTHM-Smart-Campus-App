import 'package:flutter/material.dart';

class PressAnimation extends StatefulWidget {
  const PressAnimation({
    super.key,
    required this.child,
    this.enabled = true,
    this.pressedScale = 0.96,
  });

  final Widget child;
  final bool enabled;
  final double pressedScale;

  @override
  State<PressAnimation> createState() => _PressAnimationState();
}

class _PressAnimationState extends State<PressAnimation> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled || _isPressed == value) {
      return;
    }

    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onExit: (_) => _setPressed(false),
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: AnimatedScale(
          scale: _isPressed ? widget.pressedScale : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: _isPressed ? 0.88 : 1,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
