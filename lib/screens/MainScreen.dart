import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/MyConfig.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';

class MainScreen extends StatefulWidget {
  final User? user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoading = true;
  List<Pet> pets = [];

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/get_my_pets.php'),
        body: {"user": widget.user},
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        if (body["success"] == true) {
          List data = body["pets"];

          List<Pet> fetched = data.map((e) => Pet.fromJson(e)).toList();

          setState(() {
            pets = fetched;
            isLoading = false;
          });
        } else {
          setState(() {
            pets = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          pets = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        pets = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Pet Submissions")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildContent(),
    );
  }

  Widget buildContent() {
    if (pets.isEmpty) {
      return const Center(
        child: Text("No submissions yet.", style: TextStyle(fontSize: 18)),
      );
    } else {
      return ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: buildImage(pet.imagePaths.first),
              title: Text(pet.petName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Type: ${pet.petType}"),
                  Text("Category: ${pet.category}"),
                  const SizedBox(height: 4),
                  Text(
                    pet.description.length > 40
                        ? pet.description.substring(0, 40) + "..."
                        : pet.description,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget buildImage(String path) {
    if (path == "") {
      return const Icon(Icons.image_not_supported, size: 50);
    } else {
      return Image.network(
        MyConfig.baseUrl + path,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }
  }
}
