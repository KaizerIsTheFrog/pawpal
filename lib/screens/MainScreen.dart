import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/MyConfig.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/screens/SubmitPetScreen.dart';

class MainScreen extends StatefulWidget {
  final User? user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoading = true;
  List<Pet> pets = [];

  String status = "Loading...";
  int curpage = 1;
  int numofpage = 1;
  int numofresult = 0;

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  // Inside _MainScreenState
  Future<void> loadPets() async {
    // 1. Initial State Setup
    pets.clear();
    setState(() {
      isLoading = true;
      status = "Loading...";
    });

    // 2. Validation (Ensure user ID is present for POST request)
    final userId = widget.user?.userId;
    if (userId == null || userId.isEmpty) {
      setState(() {
        isLoading = false;
        status = "Login session expired. Please log in again.";
      });
      return;
    }

    try {
      // Using POST as established for filtering by user ID
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/get_my_pets.php'),
        body: {
          "user_id": userId.toString(),
          "curpage": curpage
              .toString(), // Include current page for PHP pagination
          // If your MainScreen supports search, you can add "search": "searchQuery" here
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        // 3. Success/Data Check
        // PHP uses 'status' and 'pets' keys in the response
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['pets'] != null &&
            jsonResponse['pets'].isNotEmpty) {
          List data = jsonResponse['pets'];

          // Clear list and map items
          pets.clear();
          for (var item in data) {
            pets.add(Pet.fromJson(item));
          }

          // Update pagination results, using safe parsing
          numofpage = int.tryParse(jsonResponse['numofpage'].toString()) ?? 1;
          numofresult =
              int.tryParse(jsonResponse['numberofresult'].toString()) ?? 0;

          setState(() {
            isLoading = false;
            status = ""; // Clear status on successful load
          });
        } else {
          // 4. Success but EMPTY data (Status is 'success' or 'failed' but no pets)
          setState(() {
            pets.clear();
            isLoading = false;
            // Use the message from PHP if available, otherwise default
            status = jsonResponse['message'] ?? "No submissions yet.";
          });
        }
      } else {
        // 5. Request Failed (HTTP status code != 200)
        setState(() {
          pets.clear();
          isLoading = false;
          status = "Failed to load services (HTTP ${response.statusCode})";
        });
      }
    } catch (e) {
      // 6. Network/Decoding Error
      print("Error in loadPets: $e");
      setState(() {
        pets.clear();
        isLoading = false;
        status = "Error: Cannot connect to server.";
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetScreen(user: widget.user),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (pets.isEmpty) {
      return Center(child: Text(status, style: TextStyle(fontSize: 18)));
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
