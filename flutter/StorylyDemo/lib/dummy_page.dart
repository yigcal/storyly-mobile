import 'package:flutter/material.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({Key? key}) : super(key: key);

  @override
  _DummyPageState createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dummy-Page Example"),
      ),
      body: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Return to first page"),
      )
    );
  }

}