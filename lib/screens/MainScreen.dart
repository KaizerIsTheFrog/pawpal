import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/my_config.dart';
import 'package:pawpal/screens/LoginScreen.dart';
import 'package:pawpal/screens/SubmitPetScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final User? user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Pet> petList = [];
  String status = "Loading...";
  DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenWidth, screenHeight;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  var color;

  @override
  void initState() {
    super.initState();
    loadData('');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ${widget.user?.name}!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      backgroundColor: Color(0xFFFFF8F0),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            height: 800,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  width: screenWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ), // search bar container
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: showSearchDialog,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              "Search pet here",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Remove/Reset search criteria
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          loadData(''); // reload full list
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Search has been reset"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ), // Search bar

                const SizedBox(height: 10),
                Expanded(
                  child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      children: [
                        petList.isEmpty
                            ? Expanded(
                                // if pet list empty
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.find_in_page_outlined,
                                        size: 64,
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
                                // if pet list not empty
                                child: ListView.builder(
                                  itemCount: petList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Card(
                                      color: Colors.white,
                                      elevation: 7,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width:
                                                    screenWidth *
                                                    0.28, // more responsive
                                                height:
                                                    screenWidth *
                                                    0.22, // balanced aspect ratio
                                                color: Colors.grey[200],
                                                child: Image.network(
                                                  //Using first image uploaded as thumbnail
                                                  '${MyConfig.baseUrl}/pawpal/assets/pets/pet_${petList[index].petId}_1.png',
                                                  fit: BoxFit.fill,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return const Icon(
                                                          Icons.broken_image,
                                                          size: 60,
                                                          color: Colors.grey,
                                                        );
                                                      },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //Pet Name
                                                  Text(
                                                    petList[index].petName
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  //Pet Type
                                                  Text(
                                                    petList[index].petType
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                        255,
                                                        236,
                                                        179,
                                                        94,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            241,
                                                            197,
                                                            159,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    // Pet Category
                                                    child: Text(
                                                      petList[index].category
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDetailDialog(index);
                                              },
                                              icon: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 24,
                                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetScreen(user: widget.user),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: const Color.fromRGBO(68, 138, 255, 1)),
      ),
    );
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('rememberMe');

    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void loadData(String search) {
    setState(() {
      status = "Loading...";
    });
    petList.clear();
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/get_my_pets.php?search=$search', //search logic
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true &&
                jsonResponse['data'] != null &&
                jsonResponse['data'].isNotEmpty) {
              // load data to list
              petList.clear();
              for (var item in jsonResponse['data']) {
                petList.add(Pet.fromJson(item));
              }
              setState(() {
                status = "";
              });
            } else {
              // success but didn't have any data inserted
              setState(() {
                petList.clear();
                status = "No Data Found";
              });
            }
          } else {
            // request failed
            setState(() {
              petList.clear();
              status = "Failed to load services";
            });
          }
        });
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Search Pet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: const Color.fromARGB(255, 31, 66, 127),
            ),
          ),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(hintText: 'Search Pet (e.g. Kitty...)'),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Search',
                style: TextStyle(fontSize: 15, color: Colors.blueAccent),
              ),
              onPressed: () {
                String search = searchController.text;
                if (search.isEmpty) {
                  loadData('');
                } else {
                  loadData(search);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDetailDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(petList[index].petName.toString()),
          content: SizedBox(
            width: screenWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.25,
                    child: PageView.builder(
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        return Image.network(
                          //Display 3 images, if there are only 2 image, the third became default icon (broke icon)
                          '${MyConfig.baseUrl}/pawpal/assets/pets/pet_${petList[index].petId}_${i + 1}.png',
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(
                      color: Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    columnWidths: {
                      0: FixedColumnWidth(100.0),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            // Use TableCell to apply consistent styling/padding
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Pet Name',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petName.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                petList[index].description.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Pet Type',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].petType.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].category.toString()),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Submitter ID',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(petList[index].userId.toString()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
