import 'package:flutter/material.dart';
import 'package:form_builder_demo/forms/custom_form_builder_demo.dart';
import 'package:form_builder_demo/forms/form_builder_demo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //debugFocusChanges = true;

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

  Widget _getBody() {
    switch (_currentTab) {
      case 1:
        return FormBuilderDemo();
      default:
        return CustomFormBuilderDemo();
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
        bottomNavigationBar: FocusScope(
          child: BottomNavigationBar(
            currentIndex: _currentTab,
            onTap: (int index) {
              setState(() {
                _currentTab = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "Applied Changes",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "Default Form Builder",
              ),
            ],
          ),
        ));
  }
}
