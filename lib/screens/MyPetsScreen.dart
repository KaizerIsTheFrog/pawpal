import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/widgets/MyDrawer.dart';

class MyPetsScreen extends StatefulWidget {
  final User? user;

  const MyPetsScreen({super.key, required this.user});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Pets',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: Text(
          "Pets of ${widget.user?.name ?? 'Guest'}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
