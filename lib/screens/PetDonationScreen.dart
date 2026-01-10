import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/my_config.dart';
import 'package:pawpal/screens/PaymentPage.dart';
import 'package:pawpal/widgets/MyDrawer.dart';

class PetDonationScreen extends StatefulWidget {
  final User? user;
  final Pet? pet;

  const PetDonationScreen({super.key, required this.user, required this.pet});

  @override
  State<PetDonationScreen> createState() => _PetDonationScreenState();
}

class _PetDonationScreenState extends State<PetDonationScreen> {
  late double screenWidth, screenHeight;

  // Donation type selection
  String selectedDonationType = 'Money';

  // Controllers
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donating to ${widget.pet?.petName ?? 'Pet'}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),

      drawer: MyDrawer(user: widget.user),

      backgroundColor: Color(0xFFFFF8F0),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Info Card
            Text(
              'Donating to: ',
              style: TextStyle(fontSize: 14, color: Colors.orange[800]),
            ),
            SizedBox(height: 4),
            Text(
              widget.pet?.petName ?? 'Unknown Pet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[900],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Select Donation Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

            // Dropdown Menu Donation Type
            DropdownButtonFormField<String>(
              initialValue: selectedDonationType,
              decoration: InputDecoration(
                labelText: 'Select Donation Type',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orangeAccent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.deepOrangeAccent,
                    width: 2,
                  ),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'Money', child: Text('Money')),
                DropdownMenuItem(value: 'Food', child: Text('Food')),
                DropdownMenuItem(value: 'Medical', child: Text('Medical')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  selectedDonationType = newValue!;

                  // Clear fields when switching types
                  amountController.clear();
                  descriptionController.clear();
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select pet gender';
                }
                return null;
              },
            ),

            SizedBox(height: 24),

            // If Money Donation, show amount input, else show description input
            if (selectedDonationType == 'Money') ...[
              Text(
                'Enter Amount (RM)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Enter amount here',
                  prefixIcon: Icon(Icons.attach_money, color: Colors.orange),
                  prefixText: 'RM ',
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
              ),
            ] else ...[
              Text(
                'Describe Your Donation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                maxLines: 6,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: selectedDonationType == 'Food'
                      ? 'e.g., 5kg of cat food'
                      : 'e.g., Antibiotics',
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
                  alignLabelWithHint: true,
                ),
              ),
            ],

            SizedBox(height: 32),

            // Submit Button
            isProcessing
                ? Center(child: CircularProgressIndicator(color: Colors.green))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      minimumSize: Size(screenWidth, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      _handleDonation();
                    },
                    child: Text(
                      selectedDonationType == 'Money'
                          ? 'Proceed to Payment'
                          : 'Submit Donation',
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
    );
  }

  // Handle Donation Submission
  void _handleDonation() {
    // Validation
    if (selectedDonationType == 'Money') {
      if (amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter an amount'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Validate amount is a valid number
      double? amount = double.tryParse(amountController.text);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid amount'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Proceed to payment gateway
      _showPaymentDialog(amount);
    } else {
      // Food or Medical
      if (descriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a description'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Submit directly to backend
      _submitDonation();
    }
  }

  // Show Payment Dialog for Billplz Payment Gateway
  void _showPaymentDialog(double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [Text('Payment Gateway')]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.credit_card, size: 64, color: Colors.deepOrangeAccent),
              SizedBox(height: 16),
              Text(
                'Amount: RM ${amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Proceed to Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to PaymentPage with Billplz integration
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      user: widget.user,
                      pet: widget.pet,
                      amount: amount,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Submit Donation to Backend
  void _submitDonation() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_donation.php'),
        body: {
          'pet_id': widget.pet?.petId ?? '',
          'user_id': widget.user?.userId ?? '',
          'donation_type': selectedDonationType,
          'amount': selectedDonationType == 'Money'
              ? amountController.text
              : '0',
          'description': descriptionController.text,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Donation submitted successfully!',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back after 2 seconds
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                jsonResponse['message'] ?? 'Failed to submit donation',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        SnackBar(
          content: Text('Server error: ${response.statusCode}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        );
      }
    } catch (e) {
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }
}
