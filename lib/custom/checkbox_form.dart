import 'package:flutter/material.dart';

class CheckboxForm extends FormField<bool> {
  CheckboxForm({
    super.key,
    super.initialValue,
    super.onSaved,
    bool tristate = false,
    ValueChanged<bool>? onChanged,
    InputDecoration decoration = const InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
    ),
  }) : super(
          builder: (FormFieldState<bool> field) {
            final state = field as _CheckboxFormState;
            void onChangedHandler(bool? value) {
              field.didChange(value);
              if (onChanged != null && value != null) {
                onChanged(value);
              }
            }

            return InputDecorator(
              decoration: decoration,
              child: Checkbox(
                value: tristate ? state.value : (state.value ?? false),
                onChanged: onChangedHandler,
                tristate: tristate,
              ),
            );
          },
        );

  @override
  FormFieldState<bool> createState() => _CheckboxFormState();
}

class _CheckboxFormState extends FormFieldState<bool> {}
