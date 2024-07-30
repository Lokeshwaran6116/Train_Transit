import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_transit/components/date_picker.dart';
import 'package:train_transit/components/loc_book.dart';
import 'package:train_transit/pages/available_trains_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController generalController = TextEditingController();

  final List<String> trainStations = [
    'Chennai Egmore',
    'Tambaram',
    'Chengalpattu Junction',
    'Villupuram Junction',
    'Tiruchirappalli Junction',
    'Dindigul Junction',
    'Madurai Junction',
  ];

  final List<String> classOptions = [
    'AC First Class (1A)',
    'AC 2 Tier (2A)',
    'First Class (FC)',
    'AC 3 Tier (3A)',
  ];

  final List<String> generalOptions = [
    'Ladies',
    'Duty Pass',
    'Tatkal',
    'Premium Tatkal',
  ];

  String _travelOption = 'Traveler';

  void searchTrains(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookings')
            .add({
          'date': dateController.text.trim(),
          'from': fromController.text.trim(),
          'to': toController.text.trim(),
          'class': classController.text.trim(),
          'general': generalController.text.trim(),
          'travelOption': _travelOption,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AvailableTrainsPage(
            toStation: toController.text.trim(), // Pass the to station
            travelDate: dateController.text.trim(), // Pass the date
          )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated. Please log in.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CustomDatePicker(controller: dateController),
                const SizedBox(height: 20),
                CustomDropdown(
                  controller: fromController,
                  options: trainStations,
                  label: 'From',
                ),
                CustomDropdown(
                  controller: toController,
                  options: trainStations,
                  label: 'To',
                ),
                CustomDropdown(
                  controller: classController,
                  options: classOptions,
                  label: 'Classes',
                ),
                CustomDropdown(
                  controller: generalController,
                  options: generalOptions,
                  label: 'General',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Traveler'),
                        leading: Radio<String>(
                          value: 'Traveler',
                          groupValue: _travelOption,
                          onChanged: (String? value) {
                            setState(() {
                              _travelOption = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Deliverer'),
                        leading: Radio<String>(
                          value: 'Deliverer',
                          groupValue: _travelOption,
                          onChanged: (String? value) {
                            setState(() {
                              _travelOption = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => searchTrains(context),
                    child: const Text('Search Trains'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
