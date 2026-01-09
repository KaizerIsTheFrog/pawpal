import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/widgets/MyDrawer.dart';

class PetDetailsScreen extends StatefulWidget {
  final User? user;

  const PetDetailsScreen({super.key, required this.user});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: Text(
          "Pet Details of ${widget.user?.name ?? 'Guest'}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
