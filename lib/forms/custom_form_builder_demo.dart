// ignore_for_file: prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart'
    hide
        FormBuilderDateTimePicker,
        FormBuilderTextField,
        FormBuilderCheckbox,
        FormBuilderChoiceChip,
        FormBuilderDateRangePicker,
        FormBuilderSlider,
        FormBuilderRangeSlider;
import 'package:form_builder_demo/custom/custom_autocomplete.dart';
import 'package:form_builder_demo/custom/custom_checkbox.dart';
import 'package:form_builder_demo/custom/custom_choice_chip.dart';
import 'package:form_builder_demo/custom/custom_date_range_picker.dart';
import 'package:form_builder_demo/custom/custom_date_time_picker.dart';
import 'package:form_builder_demo/custom/custom_file_picker.dart';
import 'package:form_builder_demo/custom/custom_range_slider.dart';
import 'package:form_builder_demo/custom/custom_slider.dart';
import 'package:form_builder_demo/custom/custom_text_field.dart';
import 'package:form_builder_demo/custom/custom_typeahead.dart';
import 'package:form_builder_demo/data.dart';
import 'package:form_builder_demo/utils/responsive_body.dart';
import 'package:form_builder_demo/utils/responsive_row_column_widget.dart';
// import 'package:form_builder_file_picker/form_builder_file_picker.dart';
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
class CustomFormBuilderDemo extends StatelessWidget {
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
                  Text("All widgets can be focused by either clicking on them, "
                      "or navigating through them with the TAB key. "),
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
                          "After an image is chosen, the field keeps the focus for further navigation.",
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
                          "The checkbox takes the focus if clicked or navigated through. "
                          "This closes any opened keyboard.",
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
                            "The DatePicker can be opened via click directly and keeps "
                            "its focus after picking a date. It can also be navigated through and opened "
                            "by pressing the space key.",
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
                            "The DateRangePicker can be opened via click directly and keeps "
                            "its focus after picking a date. It can also be navigated through and opened "
                            "by pressing the space key.",
                        helperMaxLines: 7,
                      ),
                    ),
                  ),
                  FormBuilderChoiceChip(
                    name: "userDevice",
                    decoration: InputDecoration(
                      labelText: "Your device",
                      helperText:
                          "The choice chips take the focus if clicked or navigated through. "
                          "This closes any opened keyboard.",
                      helperMaxLines: 5,
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
                  ResponsiveRowColumnWidget(
                    divider: false,
                    firstWidget: FormBuilderTypeAhead<String>(
                      decoration: const InputDecoration(
                        labelText: 'Your country (TypeAhead)',
                      ),
                      name: 'countryTypeAhead',
                      allowOnlyValuesFromSelectlist: false,
                      itemBuilder: (context, country) {
                        return ListTile(title: Text(country));
                      },
                      controller: TextEditingController(text: ''),
                      suggestionsCallback: (query) {
                        if (query.isNotEmpty) {
                          var lowercaseQuery = query.toLowerCase();
                          return countries.where((country) {
                            return country
                                .toLowerCase()
                                .contains(lowercaseQuery);
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
                    secondWidget: FormBuilderAutocomplete(
                      name: "countryAutocomplete",
                      decoration: InputDecoration(
                        labelText: "Your country (Autocomplete)",
                        helperText:
                            "The autocomplete gives suggestions that you can navigate through "
                            "with the arrow-keys. Press enter to select an option.",
                        helperMaxLines: 5,
                      ),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return countries;
                        }
                        return countries.where((String option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                    ),
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
                          state.fields["countryAutocomplete"]!.focus();
                        },
                        child: Text("'Your country (Autocomplete)'"),
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
