import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_demo/data.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class FormBuilderBody extends StatefulWidget {
  const FormBuilderBody({super.key});

  @override
  State<FormBuilderBody> createState() => _FormBuilderBodyState();
}

class _FormBuilderBodyState extends State<FormBuilderBody> {
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(),
                FormBuilderTextField(
                    name: "exampleTextField",
                    // keyboardType: TextInputType.number,
                    // textInputAction: TextInputAction.search,
                    decoration:
                        const InputDecoration(labelText: "Example Text Field")),
                FormBuilderCheckbox(
                  name: "exampleCheckbox",
                  title: const Text("Example Checkbox"),
                ),
                FormBuilderTextField(
                    name: "exampleTextField2",
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                        labelText: "Example Text Field 2")),
                FormBuilderDropdown(
                  name: "exampleDropDown",
                  items: dropdownItems,
                ),
                FormBuilderDateRangePicker(
                    name: "dateRangePicker",
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 7))),
                FormBuilderDateTimePicker(
                  name: "dateTimePicker",
                  initialTime: TimeOfDay.now(),
                  resetIcon: const Icon(Icons.restore),
                ),
                FormBuilderChoiceChip(name: "choiceChip", options: const [
                  FormBuilderChipOption(
                      value: "item1", avatar: Icon(Icons.access_alarm)),
                  FormBuilderChipOption(
                      value: "item2", avatar: Icon(Icons.no_accounts)),
                  FormBuilderChipOption(
                      value: "item3", avatar: Icon(Icons.join_full)),
                ]),
                FormBuilderSearchableDropdown<String>(
                  name: "searchableDropdown",
                  autoValidateMode: AutovalidateMode.always,
                  popupProps: const PopupProps.menu(showSearchBox: true),
                  dropdownSearchDecoration: const InputDecoration(
                    hintText: 'Search',
                    labelText: 'Search',
                  ),
                  items: stringItems,
                  decoration:
                      const InputDecoration(labelText: 'Searchable Dropdown'),
                  filterFn: (item, filter) =>
                      item.toLowerCase().contains(filter.toLowerCase()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
