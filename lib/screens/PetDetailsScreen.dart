import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/my_config.dart';
import 'package:pawpal/screens/MainScreen.dart';
import 'package:pawpal/screens/PetDonationScreen.dart';
import 'package:pawpal/widgets/MyDrawer.dart';

class PetDetailsScreen extends StatefulWidget {
  final User? user;
  final Pet? pet;

  const PetDetailsScreen({super.key, required this.user, required this.pet});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  late double screenWidth, screenHeight;
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pet?.petName ?? 'Pet Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),

      drawer: MyDrawer(user: widget.user),

      backgroundColor: Color(0xFFFFF8F0),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery Section
            Container(
              width: screenWidth,
              height: screenHeight * 0.35,
              color: Colors.grey[200],
              child: PageView.builder(
                itemCount: 3, // up to 3 images
                onPageChanged: (index) {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    '${MyConfig.baseUrl}/pawpal/assets/pets/pet_${widget.pet?.petId}_${index + 1}.png',
                    fit: BoxFit.cover,

                    // error if image not found
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 80, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'No image available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 8),

            // Text to tell user scroll right
            Center(
              child: Text(
                'Scroll right for more ->',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Pet Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet Name
                  Text(
                    widget.pet?.petName ?? 'Unknown Name',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Pet Type and Category
                  Row(
                    children: [
                      // Pet Type Tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withAlpha(64),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.pet?.petType ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),

                      SizedBox(width: 8),

                      // Pet Category Tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withAlpha(64),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.pet?.category ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Quick Info Cards
                  Row(
                    children: [
                      // Age Section
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.cake,
                          label: 'Age',
                          value: widget.pet?.age ?? 'Unknown',
                        ),
                      ),

                      SizedBox(width: 12),

                      // Gender Section
                      Expanded(
                        child: _buildInfoCard(
                          icon: widget.pet?.gender == 'Male'
                              ? Icons.male
                              : widget.pet?.gender == 'Female'
                              ? Icons.female
                              : Icons.question_mark,
                          label: 'Gender',
                          value: widget.pet?.gender ?? 'Unknown',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Health Status Section
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.medication, color: Colors.deepOrange),
                            SizedBox(width: 8),
                            Text(
                              'Health Status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.pet?.healthStatus ??
                              'No information available',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Description Section
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.deepOrange),
                            SizedBox(width: 8),
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.pet?.description ?? 'No description available',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Posteder Information Section
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.deepOrange),
                            SizedBox(width: 8),
                            Text(
                              'Poster Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.person, size: 20, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Name: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.pet?.name ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(Icons.email, size: 20, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Email: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.pet?.email ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(Icons.phone, size: 20, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Phone: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.pet?.phone ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // If donation category, show Donate button, otherwise show Adopt button
                  widget.pet?.category?.toLowerCase() == 'donation request'
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            minimumSize: Size(screenWidth, 50),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetDonationScreen(
                                  user: widget.user,
                                  pet: widget.pet,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Donate To This Pet',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.volunteer_activism,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            minimumSize: Size(screenWidth, 50),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            showAdoptionRequestDialog();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Request to Adopt This Pet',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.pets, color: Colors.white),
                            ],
                          ),
                        ),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build pet info sections
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.orangeAccent),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Adoption Request Dialog
  void showAdoptionRequestDialog() {
    TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Motivation Message',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Provide a short message on why you want to adopt this pet.',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: messageController,
                  maxLines: 5,
                  maxLength: 64,
                  decoration: InputDecoration(
                    labelText: 'Tell us why you want to adopt this pet...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              child: Text(
                'Submit Request',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                if (messageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a motivation message'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Exit dialog and submit request
                submitPet(messageController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void submitPet(String message) async {
    await http
        .post(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/submit_adoption_request.php',
          ),
          body: {
            'pet_id': widget.pet?.petId,
            'requester_user_id': widget.user?.userId,
            'message': message,
            'status': 'Pending',
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(user: widget.user),
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
}
