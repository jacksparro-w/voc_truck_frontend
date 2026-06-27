import 'package:flutter/material.dart';

import '../services/cargo_type_service.dart';

class CreateCargoTypeScreen extends StatefulWidget {
  const CreateCargoTypeScreen({super.key});

  @override
  State<CreateCargoTypeScreen> createState() => _CreateCargoTypeScreenState();
}

class _CreateCargoTypeScreenState extends State<CreateCargoTypeScreen> {
  final service = CargoTypeService();
  final nameController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> createCargoType() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter cargo type name")),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await service.createCargoType({
        "name": name,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cargo Type Created")));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Cargo Type")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Cargo Type Name"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: loading ? null : createCargoType,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Create Cargo Type"),
            ),
          ],
        ),
      ),
    );
  }
}
