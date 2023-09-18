import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_demo/custom/clear_button.dart';

class FormBuilderAutocomplete<T extends Object>
    extends FormBuilderFieldDecoration<T> {
  FormBuilderAutocomplete({
    super.key,
    super.autovalidateMode,
    super.enabled,
    super.focusNode,
    super.onSaved,
    super.validator,
    super.decoration,
    super.initialValue,
    super.onChanged,
    required super.name,
    required AutocompleteOptionsBuilder<T> optionsBuilder,
    void Function(T)? onSelected,
  }) : super(builder: (FormFieldState<T?> field) {
          final state = field as FormBuilderAutocompleteState<T>;

          return RawAutocomplete<T>(
              optionsBuilder: optionsBuilder,
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<T> onSelected, Iterable<T> options) {
                return _AutocompleteOptions<T>(
                  displayStringForOption:
                      RawAutocomplete.defaultStringForOption,
                  onSelected: onSelected,
                  options: options,
                  maxOptionsHeight: 200,
                );
              },
              onSelected: state.didChange,
              textEditingController: state._autocompleteController,
              focusNode: state.effectiveFocusNode,
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: state.isNotEmpty()
                      ? decoration.copyWith(
                          suffixIcon: ClearButton(
                          fieldState: state,
                        ))
                      : decoration,
                  onEditingComplete: () {
                    // prevent default behavior
                  },
                  onFieldSubmitted: (value) {
                    onFieldSubmitted();
                  },
                );
              });
        });

  @override
  FormBuilderAutocompleteState<T> createState() =>
      FormBuilderAutocompleteState<T>();
}

class FormBuilderAutocompleteState<T extends Object>
    extends FormBuilderFieldDecorationState<FormBuilderAutocomplete<T>, T> {
  late TextEditingController _autocompleteController;

  @override
  void initState() {
    super.initState();
    _autocompleteController = TextEditingController.fromValue(
      TextEditingValue(
        text: initialValue != null
            ? RawAutocomplete.defaultStringForOption(initialValue!)
            : '',
      ),
    );
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    String newTextValue = RawAutocomplete.defaultStringForOption(value ?? '');
    _autocompleteController.value = TextEditingValue(
        text: RawAutocomplete.defaultStringForOption(value ?? ''),
        selection: TextSelection.collapsed(offset: newTextValue.length));
  }

  bool isNotEmpty() {
    return _autocompleteController.text.isNotEmpty;
  }
}

class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
  });

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxOptionsHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance
                        .addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(displayStringForOption(option)),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
