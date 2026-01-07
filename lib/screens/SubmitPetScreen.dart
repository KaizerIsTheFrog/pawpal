import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/my_config.dart';
import 'package:pawpal/screens/MainScreen.dart';

class SubmitPetScreen extends StatefulWidget {
  final User? user;
  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  List<String> petTypes = [
    'Cat',
    'Dog',
    'Bird',
    'Fish',
    'Reptile',
    'Small Mammal', // hamster or rabbit
    'Exotic Pet',
    'Amphibian',
    'Farm Animal', // goat, cow, chicken
    'Other',
  ];

  List<String> submissionCategory = [
    'Adoption',
    'Donation Request',
    'Help/Rescue',
  ];

  String selectedPetType = 'Cat'; //Default
  String selectedCategory = 'Adoption'; //Default
  String? petName;
  String? locationLongtitude;
  String? description;

  TextEditingController longtitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  late Position position;
  late double screenWidth, screenHeight;
  List<Uint8List?> webImage = [null, null, null];
  List<File?> image = [null, null, null];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool visibleSecondImagePicker = false;
  bool visibleThirdImagePicker = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determineLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),

      appBar: AppBar(
        title: Text('Submit a Pet'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.all(16.0),

            child: Column(
              // column of input fields
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          // image pickers
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            const SizedBox(width: 16),

                            //First Image Picker (Using Index to determine/detection)
                            GestureDetector(
                              onTap: () {
                                if (kIsWeb) {
                                  //Website
                                  openGallery(0);
                                } else {
                                  //Mobile
                                  pickimagedialog(0);
                                }
                              },
                              child: Container(
                                width: screenWidth / 2,
                                height: screenHeight / 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  image: (image[0] != null && !kIsWeb)
                                      ? DecorationImage(
                                          image: FileImage(image[0]!),
                                          fit: BoxFit.cover,
                                        )
                                      : (webImage[0] != null)
                                      ? DecorationImage(
                                          image: MemoryImage(webImage[0]!),
                                          fit: BoxFit.cover,
                                        )
                                      : null, // If no image, show the default icon
                                ),

                                // If didn't select the image, show camera icon
                                child: (image[0] == null && webImage[0] == null)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "Tap to add image",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                            ),

                            const SizedBox(width: 16),

                            //Second Image Picker
                            Visibility(
                              visible: visibleSecondImagePicker,
                              child: GestureDetector(
                                onTap: () {
                                  if (kIsWeb) {
                                    //Website
                                    openGallery(1);
                                  } else {
                                    //Mobile
                                    pickimagedialog(1);
                                  }
                                },
                                child: Container(
                                  width: screenWidth / 2,
                                  height: screenHeight / 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    image: (image[1] != null && !kIsWeb)
                                        ? DecorationImage(
                                            image: FileImage(image[1]!),
                                            fit: BoxFit.cover,
                                          )
                                        : (webImage[1] != null)
                                        ? DecorationImage(
                                            image: MemoryImage(webImage[1]!),
                                            fit: BoxFit.cover,
                                          )
                                        : null, // If no image, show the default icon
                                  ),

                                  // If didn't select the image, show camera icon
                                  child:
                                      (image[1] == null && webImage[1] == null)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.camera_alt,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              "Tap to add image",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            //Third Image Picker
                            Visibility(
                              visible: visibleThirdImagePicker,
                              child: GestureDetector(
                                onTap: () {
                                  if (kIsWeb) {
                                    //Website
                                    openGallery(2);
                                  } else {
                                    //Mobile
                                    pickimagedialog(2);
                                  }
                                },
                                child: Container(
                                  width: screenWidth / 2,
                                  height: screenHeight / 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    image: (image[2] != null && !kIsWeb)
                                        ? DecorationImage(
                                            image: FileImage(image[2]!),
                                            fit: BoxFit.cover,
                                          )
                                        : (webImage[2] != null)
                                        ? DecorationImage(
                                            image: MemoryImage(webImage[2]!),
                                            fit: BoxFit.cover,
                                          )
                                        : null, // If no image, show the default icon
                                  ),

                                  // If didn't select the image, show camera icon
                                  child:
                                      (image[2] == null && webImage[2] == null)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.camera_alt,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              "Tap to add image",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      TextFormField(
                        // Pet name textformfield
                        decoration: InputDecoration(
                          labelText: 'Pet Name',
                          hintText: 'Enter your pet name',
                          border: OutlineInputBorder(),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in pet name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          petName = value;
                        },
                      ),

                      SizedBox(height: 16),

                      // Pet Type
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Pet Types',
                          hintText: 'What is your pet type?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 2,
                            ),
                          ),
                        ),
                        items: petTypes.map((String selectpets) {
                          return DropdownMenuItem<String>(
                            value: selectpets,
                            child: Text(selectpets),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPetType = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select pet type';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // Category
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          hintText: 'Select your category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 2,
                            ),
                          ),
                        ),
                        items: submissionCategory.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select pet type';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      //Description (Minimum 10 Charaters)
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Select Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in the description";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          description = value;
                        },
                        maxLines: 2,
                        maxLength: 64,
                      ),

                      //Location (Longitude)
                      TextFormField(
                        controller: longtitudeController,
                        decoration: InputDecoration(
                          labelText: 'Longtitude',
                          hintText: 'Enter longtitute here',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.location_on, color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in longtitude";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          locationLongtitude = value;
                        },
                      ),

                      const SizedBox(height: 16),

                      //Location (Latitude)
                      TextFormField(
                        controller: latitudeController,
                        decoration: InputDecoration(
                          labelText: 'Longtitude',
                          hintText: 'Enter longtitute here',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Icon(Icons.location_on, color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in latitude";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          locationLongtitude = value;
                        },
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          minimumSize: Size(screenWidth, 50),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          validateForm();
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> determineLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    position = await Geolocator.getCurrentPosition();
    autoFillLocation();
  }

  void autoFillLocation() {
    longtitudeController.text = position.longitude.toString();
    latitudeController.text = position.latitude.toString();
  }

  Future<void> openGallery(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage[index] = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image[index] = File(pickedFile.path);
        cropImage(index); // only for mobile
      }
    }
  }

  void pickimagedialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera(index);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openCamera(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage[index] = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image[index] = File(pickedFile.path);
        cropImage(index);
      }
    }
  }

  Future<void> cropImage(int index) async {
    if (kIsWeb) {
      if (index == 0) {
        setState(() {
          visibleSecondImagePicker = true;
        });
      }
      if (index == 1) {
        setState(() {
          visibleThirdImagePicker = true;
        });
      }
      return;
    } // skip cropping on web
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image[index]!.path,
      aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );

    if (croppedFile != null) {
      image[index] = File(croppedFile.path);
      if (index == 0) {
        visibleSecondImagePicker = true;
      }
      if (index == 1) {
        visibleThirdImagePicker = true;
      }
      setState(() {});
    }
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      //Check Image (At least upload 1 image)
      if (kIsWeb) {
        if (webImage[0] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please upload at least 1 image',
                style: TextStyle(fontSize: 15),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
      } else {
        if (image[0] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please upload at least 1 image',
                style: TextStyle(fontSize: 15),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
      }

      //Perform textformfield save operation
      formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Submit New Pet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 28, 59, 112),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitPet();
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          content: Text(
            'Are you sure you want to submit this submission?',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      );
    } else {
      return;
    }
  }

  void submitPet() async {
    List<String?> base64image = [];
    if (kIsWeb) {
      for (int x = 0; x <= 2; x++) {
        if (webImage[x] == null) {
          continue;
        }
        base64image.add(base64Encode(webImage[x]!));
      }
    } else {
      for (int x = 0; x <= 2; x++) {
        if (image[x] == null) {
          continue;
        }
        base64image.add(base64Encode(image[x]!.readAsBytesSync()));
      }
    }
    print(base64image);
    String latitude = latitudeController.text.trim();
    String longitude = longtitudeController.text.trim();

    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_pet.php'),
          body: {
            'user_id': widget.user?.userId,
            'pet_name': petName,
            'pet_type': selectedPetType,
            'category': selectedCategory,
            'description': description,
            'lat': latitude,
            'lng': longitude,
            'image': jsonEncode(base64image),
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
