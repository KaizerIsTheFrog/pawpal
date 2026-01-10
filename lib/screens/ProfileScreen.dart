import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/my_config.dart';
import 'package:pawpal/widgets/MyDrawer.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenWidth, screenHeight;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Uint8List? webImage;
  File? image;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Get current user info
    nameController.text = widget.user?.name ?? '';
    emailController.text = widget.user?.email ?? '';
    phoneController.text = widget.user?.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth > 600) {
      screenWidth = 600;
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: MyDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // image picker
                GestureDetector(
                  onTap: () {
                    if (kIsWeb) {
                      //Website
                      openGallery();
                    } else {
                      //Mobile
                      pickImageDialog();
                    }
                  },
                  child: Container(
                    width: screenWidth / 2,
                    height: screenHeight / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade400),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],

                      // Display selected image or existing profile image
                      image: (image != null && !kIsWeb)
                          ? DecorationImage(
                              image: FileImage(image!),
                              fit: BoxFit.cover,
                            )
                          : (webImage != null)
                          ? DecorationImage(
                              image: MemoryImage(webImage!),
                              fit: BoxFit.cover,
                            )
                          : (widget.user?.profileImagePath != null)
                          ? DecorationImage(
                              image: NetworkImage(
                                '${MyConfig.baseUrl}/pawpal/assets/${widget.user!.profileImagePath}',
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),

                    // If didn't select the image AND no profile yet, show camera icon
                    child:
                        (image == null &&
                            webImage == null &&
                            widget.user?.profileImagePath == null)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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

                SizedBox(height: 24),

                // Info Card
                Card(
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Tap the profile image to change it.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orangeAccent.shade700,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Edit Profile Form
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Name Field
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.orangeAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      // Email Field (Read-only)
                      TextFormField(
                        controller: emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Email (Cannot be changed)',
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Phone Field
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.orangeAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 24),

                      // Update Button
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.orangeAccent,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                                minimumSize: Size(screenWidth, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              onPressed: () {
                                validateAndUpdate();
                              },
                              child: Text(
                                'Update Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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

  // Pick image dialog
  void pickImageDialog() {
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
                  openCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Open gallery
  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage();
      }
    }
  }

  // Open camera
  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage();
      }
    }
  }

  // Crop image
  Future<void> cropImage() async {
    if (kIsWeb) return; // Skip cropping on web

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Picture',
          toolbarColor: Colors.orangeAccent,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(
          title: 'Crop Profile Picture',
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
      ],
    );

    if (croppedFile != null) {
      image = File(croppedFile.path);
      setState(() {});
    }
  }

  // Validate and update
  void validateAndUpdate() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Updating Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Text(
            'Are you sure you want to update your profile?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              onPressed: () {
                Navigator.pop(context);
                updateProfile();
              },
              child: Text(
                'Update',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Update profile
  void updateProfile() async {
    setState(() {
      isLoading = true;
    });

    String? base64Image;

    // Encode image if exists
    if (kIsWeb && webImage != null) {
      base64Image = base64Encode(webImage!);
    } else if (!kIsWeb && image != null) {
      base64Image = base64Encode(image!.readAsBytesSync());
    }

    await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_profile.php'),
          body: {
            'user_id': widget.user?.userId,
            'name': nameController.text.trim(),
            'phone': phoneController.text.trim(),
            if (base64Image != null) 'image': base64Image,
          },
        )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success']) {
              widget.user?.name = nameController.text.trim();
              widget.user?.phone = phoneController.text.trim();

              if (resarray['profile_image_path'] != null) {
                widget.user?.profileImagePath = resarray['profile_image_path'];
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: widget.user),
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
