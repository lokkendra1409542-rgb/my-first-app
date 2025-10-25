import 'package:flutter/material.dart';

/// A reusable scrollable body used across dashboard sections so that every
/// screen gets consistent padding, spacing and min-height behaviour.
class AppPageBody extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;

  const AppPageBody({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(32, 28, 32, 40),
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                ..._withSpacing(children),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _withSpacing(List<Widget> items) {
    final spaced = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      spaced.add(items[i]);
      if (i != items.length - 1) {
        spaced.add(const SizedBox(height: 24));
      }
    }
    return spaced;
  }
}
