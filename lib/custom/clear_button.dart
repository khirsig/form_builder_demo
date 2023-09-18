import 'package:flutter/material.dart';

class ClearButton<T> extends StatelessWidget {
  final dynamic fieldState;
  final Icon? icon;

  const ClearButton({
    Key? key,
    required this.fieldState,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ??
          const Icon(
            Icons.clear,
          ),
      onPressed: () {
        fieldState.didChange(null);
      },
    );
  }
}
