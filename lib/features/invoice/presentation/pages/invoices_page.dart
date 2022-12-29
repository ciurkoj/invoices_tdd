import 'package:flutter/material.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  InvoicesPageState createState() => InvoicesPageState();
}

class InvoicesPageState extends State<InvoicesPage> {
  bool isLoading = false;
  String? searchByValue;

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoices',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {},
      ),
    );
  }




}
