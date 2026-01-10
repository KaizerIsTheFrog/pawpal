import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/models/donation.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/my_config.dart';
import 'package:pawpal/widgets/MyDrawer.dart';

class MyDonationsScreen extends StatefulWidget {
  final User? user;
  const MyDonationsScreen({super.key, required this.user});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  List<Donation> donationList = [];
  String status = "Loading...";
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadDonations();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Donations',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: MyDrawer(user: widget.user),
      backgroundColor: Color(0xFFFFF8F0),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            height: 800,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // Donations List
                Expanded(
                  child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      children: [
                        donationList.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.volunteer_activism_outlined,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        status,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: donationList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Card(
                                      color: Colors.white,
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header Row
                                            Row(
                                              children: [
                                                // Donation Type Icon
                                                // Container
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withAlpha(64),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    // change icon based on donation type
                                                    switch (donationList[index]
                                                        .donationType) {
                                                      'Money' =>
                                                        Icons.attach_money,
                                                      'Food' =>
                                                        Icons.restaurant,
                                                      'Medical' =>
                                                        Icons.medical_services,
                                                      _ =>
                                                        Icons
                                                            .volunteer_activism,
                                                    },
                                                    color: Colors.orangeAccent,
                                                    size: 28,
                                                  ),
                                                ),

                                                SizedBox(width: 12),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Donation Type
                                                      Text(
                                                        'Donation Type: ${donationList[index].donationType ?? 'Unknown'}',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      // Pet Name
                                                      Text(
                                                        'For: ${donationList[index].petName ?? 'Unknown Pet'}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Amount (if Money)
                                                if (donationList[index]
                                                        .donationType ==
                                                    'Money')
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.orangeAccent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      'RM ${donationList[index].amount ?? '0'}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),

                                            SizedBox(height: 12),
                                            Divider(),
                                            SizedBox(height: 12),

                                            // Description
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.description,
                                                  size: 18,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    (donationList[index]
                                                                    .description ==
                                                                null ||
                                                            donationList[index]
                                                                .description!
                                                                .isEmpty)
                                                        ? 'No description provided.'
                                                        : donationList[index]
                                                              .description!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 8),

                                            // Date
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  formatter.format(
                                                    DateTime.parse(
                                                      donationList[index]
                                                              .donationDate ??
                                                          DateTime.now()
                                                              .toString(),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Load Donations from Backend
  void loadDonations() async {
    String url =
        '${MyConfig.baseUrl}/pawpal/api/get_my_donations.php?user_id=${widget.user!.userId}';

    setState(() {
      status = "Loading...";
    });

    donationList.clear();

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true &&
            jsonResponse['data'] != null &&
            jsonResponse['data'].isNotEmpty) {
          donationList.clear();
          for (var item in jsonResponse['data']) {
            donationList.add(Donation.fromJson(item));
          }
          setState(() {
            status = "";
          });
        } else {
          setState(() {
            donationList.clear();
            status = "No donations yet";
          });
        }
      } else {
        setState(() {
          donationList.clear();
          status = "Failed to load donations";
        });
      }
    } catch (e) {
      setState(() {
        donationList.clear();
        status = "Error: $e";
      });
    }
  }
}
