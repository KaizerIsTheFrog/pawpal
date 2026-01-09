import 'package:flutter/material.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/widgets/MyDrawer.dart';

class PetDonationScreen extends StatefulWidget {
  final User? user;
  final Pet? pet;

  const PetDonationScreen({super.key, required this.user, required this.pet});

  @override
  State<PetDonationScreen> createState() => _PetDonationScreenState();
}

class _PetDonationScreenState extends State<PetDonationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Donations',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: Text(
          "Donation to ${widget.pet?.petName ?? 'Guest'}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
