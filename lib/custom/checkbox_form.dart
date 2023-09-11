import 'package:flutter/material.dart';

class CheckboxForm extends FormField<bool> {
  CheckboxForm({
    super.key,
    ValueChanged<bool>? onChanged,
  }) : super(
          builder: (FormFieldState<bool> field) {
            void onChangedHandler(bool? value) {
              field.didChange(value);
              if (onChanged != null && value != null) {
                onChanged(value);
              }
            }

            final bool value = field.value ?? false;

            return Checkbox(
              value: value,
              onChanged: onChangedHandler,
            );
          },
        );
}
