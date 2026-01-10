import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/my_config.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final User? user;
  final Pet? pet;
  final double amount;

  const PaymentPage({
    super.key,
    required this.user,
    required this.pet,
    required this.amount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController _controller;
  bool isLoading = true;
  String? paymentUrl;

  @override
  void initState() {
    super.initState();
    initiatePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Gateway',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.orangeAccent),
                  SizedBox(height: 16),
                  Text(
                    'Connecting to payment gateway...',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Amount: RM ${widget.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            )
          : paymentUrl != null
          ? WebViewWidget(controller: _controller)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load payment gateway',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Go Back'),
                  ),
                ],
              ),
            ),
    );
  }

  // Initiate payment with Billplz
  void initiatePayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Call payment.php to create Billplz bill using amount instead of credits
      final url = Uri.parse(
        '${MyConfig.baseUrl}/pawpal/api/payment.php?email=${widget.user?.email}&phone=${widget.user?.phone}&name=${widget.user?.name}&amount=${widget.amount}&userid=${widget.user?.userId}&petid=${widget.pet?.petId}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response to get the Billplz URL
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['url'] != null) {
          setState(() {
            paymentUrl = jsonResponse['url'];
            isLoading = false;
          });

          // Initialize WebView
          _controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (String url) {
                  // Check if redirected to payment_update.php (success/failure)
                  if (url.contains('payment_update.php')) {
                    // Payment completed, parse the result
                    _handlePaymentComplete(url);
                  }
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                onWebResourceError: (WebResourceError error) {
                  print('Web resource error: ${error.description}');
                },
              ),
            )
            ..loadRequest(Uri.parse(paymentUrl!));
        } else {
          setState(() {
            isLoading = false;
          });
          _showErrorDialog('Failed to create payment bill');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Error: $e');
    }
  }

  // Handle payment completion
  void _handlePaymentComplete(String url) {
    // Parse URL parameters to check payment status
    Uri uri = Uri.parse(url);
    String? paidStatus = uri.queryParameters['billplz[paid]'];

    if (paidStatus == 'true') {
      // Payment successful
      // Note: Donation is already inserted by payment_update.php
      // Just show success message and navigate back
      _showPaymentResult(
        true,
        'Payment successful! Thank you for your donation of RM ${widget.amount.toStringAsFixed(2)}.',
      );
    } else {
      // Payment failed
      _showPaymentResult(false, 'Payment was not completed');
    }
  }

  // Show payment result dialog
  void _showPaymentResult(bool success, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
              size: 32,
            ),
            SizedBox(width: 12),
            Text(success ? 'Success!' : 'Failed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            if (success) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your donation has been recorded in your donation history.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: success ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigator.pop(context); // Close payment page
              // if (success) {
              //   Navigator.pop(context); // Close donation screen
              // }
            },
            child: Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 12),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close payment page
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
