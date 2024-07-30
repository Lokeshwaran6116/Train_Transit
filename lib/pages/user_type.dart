import 'package:flutter/material.dart';
import 'package:train_transit/pages/delivery_page.dart';
import 'package:train_transit/pages/booking_page.dart';
import 'package:train_transit/pages/tracking_page.dart'; // Import the new page
import 'package:train_transit/components/my_button.dart';

class UserType extends StatelessWidget {
  const UserType({super.key});

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('User Type'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Heading
              Text(
                'Select User Type',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Delivery button
              MyButton(
                onTap: () => navigateToPage(context, DeliveryPage()), // Remove `const`
                text: 'Delivery',
              ),

              const SizedBox(height: 10),

              // Booking button
              MyButton(
                onTap: () => navigateToPage(context, BookingPage()), // Remove `const`
                text: 'Booking',
              ),

              const SizedBox(height: 10),

              // Tracking button
              MyButton(
                onTap: () => navigateToPage(context, TrackingPage()), // Remove `const`
                text: 'Tracking',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
