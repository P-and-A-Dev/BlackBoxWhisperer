import 'package:flutter/material.dart';

class PulseDotsLoader extends StatefulWidget {
  const PulseDotsLoader({
    super.key,
    this.size = 48,
    this.dotSize = 8,
    this.spacing = 10,
    this.period = const Duration(milliseconds: 900),
  });

  static const primary = Color(0xFF135BEC);

  final double size;
  final double dotSize;
  final double spacing;
  final Duration period;

  @override
  State<PulseDotsLoader> createState() => _PulseDotsLoaderState();
}

class _PulseDotsLoaderState extends State<PulseDotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.period)..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _dotScale(double t, double phase) {
    final v = (t + phase) % 1.0;
    return 0.6 + 0.4 * (1 - (v - 0.5).abs() * 2).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.dotSize * 2,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final scale = _dotScale(_c.value, (2 - i) * 0.15);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
                width: widget.dotSize * scale,
                height: widget.dotSize * scale,
                decoration: const BoxDecoration(
                  color: PulseDotsLoader.primary,
                  shape: BoxShape.circle,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
