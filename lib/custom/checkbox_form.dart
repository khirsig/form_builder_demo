import 'package:flutter/material.dart';

class CheckboxForm extends FormField<bool> {
  final FocusNode? focusNode;
  CheckboxForm({
    super.key,
    super.initialValue,
    super.onSaved,
    bool tristate = false,
    ValueChanged<bool>? onChanged,
    this.focusNode,
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
              state.focus();
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
                focusNode: state.effectiveFocusNode,
              ),
            );
          },
        );

  @override
  FormFieldState<bool> createState() => _CheckboxFormState();
}

class _CheckboxFormState extends FormFieldState<bool> {
  @override
  CheckboxForm get widget => super.widget as CheckboxForm;

  late FocusNode effectiveFocusNode;
  FocusAttachment? focusAttachment;

  @override
  void initState() {
    super.initState();
    effectiveFocusNode = widget.focusNode ?? FocusNode(debugLabel: 'Checkbox');
    focusAttachment = effectiveFocusNode.attach(context);
  }

  @override
  void dispose() {
    focusAttachment!.detach();
    effectiveFocusNode.dispose();
    super.dispose();
  }

  void focus() {
    if (!effectiveFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(effectiveFocusNode);
    }
  }
}
