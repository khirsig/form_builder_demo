import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

List<String> listItems = [
  "Item 1",
  "Item 2",
  "Item 3",
];

List<DropdownMenuItem> dropdownItems = const [
  DropdownMenuItem(
    value: "item1",
    child: Text("Item 1"),
  ),
  DropdownMenuItem(
    value: "item2",
    child: Text("Item 2"),
  ),
  DropdownMenuItem(
    value: "item3",
    child: Text("Item 3"),
  ),
];

List<String> stringItems = const ['item1', 'item2', 'item3'];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormBuilder Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FormBuilder Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentTab = 0;
  bool _isChecked = false;

  Widget _getBody() {
    switch (_currentTab) {
      case 0:
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
                        decoration: const InputDecoration(
                            labelText: "Example Text Field")),
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
                        name: "dateTimePicker", initialTime: TimeOfDay.now()),
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
                      decoration: const InputDecoration(
                          labelText: 'Searchable Dropdown'),
                      filterFn: (item, filter) =>
                          item.toLowerCase().contains(filter.toLowerCase()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      default:
        return Form(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TextField(
                      decoration:
                          InputDecoration(labelText: "Example Text Field")),
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: _getBody()),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (int index) {
            setState(() {
              _currentTab = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "FormBuilder",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Form",
            ),
          ],
        ));
  }
}
