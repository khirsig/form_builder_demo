import 'package:flutter/material.dart';

class FormBody extends StatefulWidget {
  const FormBody({super.key});

  @override
  State<FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends State<FormBody> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TextField(
                  decoration: InputDecoration(labelText: "Example Text Field")),
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
