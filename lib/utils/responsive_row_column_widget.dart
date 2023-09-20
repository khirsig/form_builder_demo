import 'package:flutter/material.dart';

class ResponsiveRowColumnWidget extends StatelessWidget {
  final Widget firstWidget;
  final Widget secondWidget;
  final bool divider;
  final bool verticalDivider;
  final bool forceRows;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsiveRowColumnWidget(
      {Key? key,
      required this.firstWidget,
      required this.secondWidget,
      this.divider = true,
      this.forceRows = false,
      this.crossAxisAlignment = CrossAxisAlignment.stretch,
      this.verticalDivider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 800 && !forceRows) {
      return Column(
        children: [
          IntrinsicHeight(
            child: Container(
              constraints: BoxConstraints(maxHeight: 500),
              child: Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SingleChildScrollView(child: firstWidget),
                    ),
                  ),
                  if (divider || verticalDivider) VerticalDivider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SingleChildScrollView(child: secondWidget),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (divider) Divider()
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          firstWidget,
          if (divider) Divider(),
          secondWidget,
          if (divider) Divider()
        ],
      );
    }
  }
}
