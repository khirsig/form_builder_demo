// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_demo/data.dart';
import 'package:form_builder_demo/utils/responsive_body.dart';
import 'package:form_builder_demo/utils/responsive_row_column_widget.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
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
class FormBuilderDemo extends StatelessWidget {
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
                  SizedBox(height: 10),
                  Text(
                      "Most widgets can only be consistantly used via mouse clicking. "
                      "Navigating with tab provides many challenges: Some widgets "
                      "get opened directly, losing focus after that. Other widgets lose "
                      "focus after entering a value. Some widgets also never request focus "
                      "so that open keyboards never get closed."),
                  SizedBox(height: 15),
                  ResponsiveRowColumnWidget(
                    divider: false,
                    firstWidget: FormBuilderTextField(
                      name: "firstName",
                      decoration: InputDecoration(labelText: "First name"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(1)
                      ]),
                    ),
                    secondWidget: FormBuilderTextField(
                      name: "lastName",
                      decoration: InputDecoration(labelText: "Last name"),
                    ),
                  ),
                  FormBuilderFilePicker(
                    name: "image",
                    decoration: InputDecoration(
                      labelText: "User Image",
                      helperText:
                          "The image picker is opened either by clicking "
                          "or if the field is focused by pressing the space key. "
                          "After an image is chosen, the field keeps the focus for further navigation. "
                          "However, it does not visually show its focus through the decoration and "
                          "it is not possible to remove the images via tab and space.",
                      helperMaxLines: 5,
                    ),
                    typeSelectors: const [
                      TypeSelector(
                          type: FileType.image,
                          selector: Row(
                            children: [
                              Icon(Icons.image),
                              Text("Pick an user image")
                            ],
                          )),
                    ],
                  ),
                  FormBuilderCheckbox(
                    name: "terms",
                    decoration: InputDecoration(
                      labelText: "Accept terms",
                      helperText:
                          "The checkbox never gains focus if clicked on."
                          "Any open keyboard is not closed.",
                      helperMaxLines: 5,
                    ),
                    title: Text("Accept terms"),
                    validator: FormBuilderValidators.required(),
                  ),
                  ResponsiveRowColumnWidget(
                    divider: false,
                    firstWidget: FormBuilderDateTimePicker(
                      name: "birthday",
                      decoration: InputDecoration(
                        labelText: "Your date of birth",
                        helperText:
                            "The DatePicker can be opened via click directly but loses "
                            "its focus after picking a date. It can not be navigated through "
                            "only to, and then immediatly opens its picker, losing focus after. "
                            "This makes it impossible to get past it with keyboard.",
                        helperMaxLines: 7,
                      ),
                    ),
                    secondWidget: FormBuilderDateRangePicker(
                      name: "preferredVacationDate",
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 7),
                      ),
                      decoration: InputDecoration(
                        labelText: "Preferred vacation date",
                        helperText:
                            "The DateRangePicker can be opened via click directly but loses "
                            "its focus after picking a date. It can not be navigated through "
                            "only to, and then immediatly opens its picker, losing focus after. "
                            "This makes it impossible to get past it with keyboard.",
                        helperMaxLines: 7,
                      ),
                    ),
                  ),
                  FormBuilderChoiceChip(
                    name: "userDevice",
                    spacing: 4,
                    decoration: InputDecoration(
                      labelText: "Your device",
                      helperText: "The chips never gain focus if clicked on. "
                          "Any open keyboard is not closed.",
                    ),
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
                      labelText: 'Your country (TypeAhead)',
                    ),
                    name: 'countryTypeAhead',
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
                  ResponsiveRowColumnWidget(
                    divider: false,
                    firstWidget: FormBuilderRangeSlider(
                      name: "preferedPriceRange",
                      decoration: InputDecoration(label: Text("Price range")),
                      min: 0,
                      max: 100,
                      initialValue: RangeValues(20, 80),
                    ),
                    secondWidget: FormBuilderSlider(
                      name: "budget",
                      decoration: InputDecoration(label: Text("Budget")),
                      min: 0,
                      max: 100,
                      initialValue: 10,
                    ),
                  ),
                  FormBuilderDropdown<String>(
                    name: "vacationGoal",
                    decoration: InputDecoration(
                      labelText: "Preferred vacation goal",
                      helperText:
                          "Open the dropdown and navigate through the options "
                          "with the arrow keys. Press enter to select an option.",
                      helperMaxLines: 5,
                    ),
                    items: countries
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
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
                  Divider(thickness: 2),
                  Text(
                    "Click on a button below to focus any field",
                  ),
                  SizedBox(height: 5),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          state.fields["firstName"]!.focus();
                        },
                        child: Text("'First name'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["lastName"]!.focus();
                        },
                        child: Text("'Last name'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["image"]!.focus();
                        },
                        child: Text("'User image'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["terms"]!.focus();
                        },
                        child: Text("'Terms accepted'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["birthday"]!.focus();
                        },
                        child: Text("'Your date of birth'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["preferredVacationDate"]!.focus();
                        },
                        child: Text("'Preferred vacation date'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["userDevice"]!.focus();
                        },
                        child: Text("'User device'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["countryTypeAhead"]!.focus();
                        },
                        child: Text("'Your Country (TypeAhead)'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["preferedPriceRange"]!.focus();
                        },
                        child: Text("'Price range'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["budget"]!.focus();
                        },
                        child: Text("'Budget'"),
                      ),
                      TextButton(
                        onPressed: () {
                          state.fields["vacationGoal"]!.focus();
                        },
                        child: Text("'Preferred vacation goal'"),
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
