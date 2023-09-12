// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
        return ResponsiveBody(
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
              )
            ],
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
