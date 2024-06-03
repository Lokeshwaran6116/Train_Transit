import 'package:flutter/material.dart';
import 'package:train_transit/components/date_picker.dart';
import 'package:train_transit/components/loc.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController dateController = TextEditingController();

    // Sample list of train stations in India
    List<String> trainStations = [
      'New Delhi',
      'Mumbai',
      'Chennai',
      'Kolkata',
      'Bangalore',
      'Hyderabad',
      'Ahmedabad',
      'Pune',
      'Jaipur',
      'Lucknow',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CustomDatePicker(controller: dateController),
              const SizedBox(height: 20),
              StationDropdown(
                controller: TextEditingController(),
                options: trainStations,
                label: 'From',
              ),
              StationDropdown(
                controller: TextEditingController(),
                options: trainStations,
                label: 'To',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
