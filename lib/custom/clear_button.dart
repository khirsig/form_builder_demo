import 'package:flutter/material.dart';

class ClearButton<T> extends StatelessWidget {
  final FormFieldState<T> fieldState;
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
            // size: 18,
          ),
      onPressed: () {
        fieldState.didChange(null);
      },
    );
  }
}
