import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/widgets/MyDrawer.dart';

class MyDonationsScreen extends StatefulWidget {
  final User? user;

  const MyDonationsScreen({super.key, required this.user});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Donations',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: Text(
          "Donations of ${widget.user?.name ?? 'Guest'}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
