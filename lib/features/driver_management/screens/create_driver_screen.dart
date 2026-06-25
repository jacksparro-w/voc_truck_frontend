import 'package:flutter/material.dart';

import '../services/driver_management_service.dart';

class CreateDriverScreen
    extends StatefulWidget {

  const CreateDriverScreen({
    super.key,
  });

  @override
  State<CreateDriverScreen>
      createState() =>
          _CreateDriverScreenState();
}

class _CreateDriverScreenState
    extends State<CreateDriverScreen> {

  final service =
      DriverManagementService();

  final nameController =
      TextEditingController();

  final mobileController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  Future<void> createDriver()
      async {

    setState(() {
      loading = true;
    });

    try {

      await service.createDriver({

        "name":
            nameController.text,

        "mobile":
            mobileController.text,

        "password":
            passwordController.text,

        "role":
            "DRIVER",
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
              context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Driver Created",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(
              context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          "Create Driver",
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(
                20),

        child: Column(

          children: [

            TextField(
              controller:
                  nameController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Name",
              ),
            ),

            TextField(
              controller:
                  mobileController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Mobile",
              ),
            ),

            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Password",
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            ElevatedButton(
              onPressed:
                  loading
                      ? null
                      : createDriver,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Create Driver",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}