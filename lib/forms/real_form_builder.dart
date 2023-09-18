// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart'
    hide
        FormBuilderDateTimePicker,
        FormBuilderTextField,
        FormBuilderCheckbox,
        FormBuilderChoiceChip;
import 'package:form_builder_demo/custom/custom_checkbox.dart';
import 'package:form_builder_demo/custom/custom_choice_chip.dart';
import 'package:form_builder_demo/custom/custom_date_time_picker.dart';
import 'package:form_builder_demo/custom/custom_text_field.dart';
import 'package:form_builder_demo/custom/custom_typeahead.dart';
import 'package:form_builder_demo/data.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

abstract class InitialValue {
  dynamic operator [](String key);

  void operator []=(String key, dynamic value);

  void remove(String key);
}

class MyModel extends InitialValue {
  String firstName;
  String lastName;

  MyModel({
    required this.firstName,
    required this.lastName,
  });

  @override
  operator [](String key) {
    switch (key) {
      case "firstName":
        return firstName;
      case "lastName":
        return lastName;
      default:
    }
    return null;
  }

  @override
  void operator []=(String key, value) {
    switch (key) {
      case "firstName":
        firstName = value;
      case "lastName":
        lastName = value;
      default:
    }
  }

  @override
  void remove(String key) {}

  Map<String, dynamic> toMap() {
    return {};
  }
}

const double _maxWidth = 800;

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final bool addPadding;

  const ResponsiveBody({Key? key, required this.child, this.addPadding = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: addPadding ? EdgeInsets.symmetric(horizontal: 16) : null,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _maxWidth,
            minWidth: 300,
            maxHeight: double.infinity,
          ),
          child: child,
        ),
      ),
    );
  }
}

class RealFormBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, FormBuilderState state) builder;

  const RealFormBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(child: Builder(builder: (context) {
      FormBuilderState? state = FormBuilder.of(context);
      return builder(context, state!);
    }));
  }
}

// ignore: use_key_in_widget_constructors
class RealFormBuilderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RealFormBuilder(
      builder: (context, state) {
        return FocusScope(
          child: GestureDetector(
            onTap: () {
              // This allows closing keyboard when tapping outside of a text field
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: ResponsiveBody(
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "firstName",
                    decoration: InputDecoration(labelText: "First name"),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(1)
                    ]),
                  ),
                  FormBuilderTextField(
                    name: "lastName",
                    decoration: InputDecoration(labelText: "Last name"),
                  ),
                  FormBuilderCheckbox(
                    name: "terms",
                    title: Text("Terms accepted"),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderDateTimePicker(
                      name: "birthday",
                      decoration:
                          InputDecoration(labelText: "Your date of birth")),
                  FormBuilderChoiceChip(
                    name: "userDevice",
                    decoration: InputDecoration(labelText: "Your device"),
                    options: const [
                      FormBuilderChipOption(
                          value: "iPhone", avatar: Icon(Icons.apple)),
                      FormBuilderChipOption(
                          value: "Android", avatar: Icon(Icons.android)),
                      FormBuilderChipOption(
                          value: "iPad", avatar: Icon(Icons.tablet)),
                    ],
                  ),
                  FormBuilderTypeAhead<String>(
                    decoration: const InputDecoration(
                      labelText: 'Your country',
                    ),
                    name: 'country',
                    allowOnlyValuesFromSelectlist: true,
                    itemBuilder: (context, country) {
                      return ListTile(title: Text(country));
                    },
                    controller: TextEditingController(text: ''),
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return countries.where((country) {
                          return country.toLowerCase().contains(lowercaseQuery);
                        }).toList(growable: false)
                          ..sort((a, b) => a
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(
                                  b.toLowerCase().indexOf(lowercaseQuery)));
                      } else {
                        return countries;
                      }
                    },
                  ),
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (state.saveAndValidate()) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Form data"),
                                content: Text("${state.value}"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Ok"))
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("Save"),
                      )
                    ],
                  ),
                  Divider(),
                  ButtonBar(
                    children: [
                      TextButton(
                        onPressed: () {
                          state.fields["firstName"]!.focus();
                        },
                        child: Text("Focus 'First name'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["lastName"]!.focus();
                        },
                        child: Text("Focus 'Last name'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["terms"]!.focus();
                        },
                        child: Text("Focus 'Terms accepted'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["birthday"]!.focus();
                        },
                        child: Text("Focus 'Your date of birth'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["userDevice"]!.focus();
                        },
                        child: Text("Focus 'User device'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["country"]!.focus();
                        },
                        child: Text("Focus 'Your country'"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CheckboxListTile extends StatelessWidget {
  final bool value = true;
  final FocusNode focusNode = FocusNode(descendantsAreFocusable: false);
  final FocusScopeNode focusNode2 = FocusScopeNode();
  @override
  Widget build(BuildContext context) {
    return Focus(
        child: ListTile(
      title: Text("Checkbox"),
      onTap: () {},
      leading: Checkbox(value: value, onChanged: (value) {}),
    ));
  }
}
