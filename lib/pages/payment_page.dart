import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_transit/pages/ticket_page.dart';

class PaymentPage extends StatefulWidget {
  final String trainNumber;
  final String trainName;
  final String berthPreference;
  final String passengerName;
  final String passengerAge;
  final String toStation;
  final String travelDate;

  const PaymentPage({
    required this.trainNumber,
    required this.trainName,
    required this.berthPreference,
    required this.passengerName,
    required this.passengerAge,
    required this.toStation,
    required this.travelDate,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  bool _acceptedTerms = false;
  String _selectedPaymentMethod = 'Credit Card';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.passengerName);
    _ageController = TextEditingController(text: widget.passengerAge);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Page',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Passenger Name'),
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Passenger Age'),
                keyboardType: TextInputType.number,
                controller: _ageController,
              ),
              const SizedBox(height: 20),
              Text('Berth Preference: ${widget.berthPreference}'),
              const SizedBox(height: 20),
              _buildPaymentOptions(),
              const SizedBox(height: 20),
              _buildTermsAndConditions(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _canBookTicket() ? () => _bookTicket(context) : null,
                child: const Text('Confirm and Book Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListTile(
          title: const Text('Credit Card'),
          leading: Radio<String>(
            value: 'Credit Card',
            groupValue: _selectedPaymentMethod,
            onChanged: (String? value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Debit Card'),
          leading: Radio<String>(
            value: 'Debit Card',
            groupValue: _selectedPaymentMethod,
            onChanged: (String? value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Net Banking'),
          leading: Radio<String>(
            value: 'Net Banking',
            groupValue: _selectedPaymentMethod,
            onChanged: (String? value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('UPI'),
          leading: Radio<String>(
            value: 'UPI',
            groupValue: _selectedPaymentMethod,
            onChanged: (String? value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Terms and Conditions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          '1. Tickets booked through this application are subject to the rules and regulations of Indian Railways.\n'
              '2. Passengers must carry a valid ID proof during travel.\n'
              '3. Tickets are non-transferable and cannot be resold.\n'
              '4. Cancellations and refunds will be processed as per Indian Railways policies.\n'
              '5. Passengers should report at the boarding station at least 30 minutes before the scheduled departure.\n'
              '6. Indian Railways reserves the right to change the schedule or cancel the train service due to operational reasons.\n'
              '7. By proceeding with the booking, you agree to comply with all terms and conditions set by Indian Railways.',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              value: _acceptedTerms,
              onChanged: (bool? value) {
                setState(() {
                  _acceptedTerms = value ?? false;
                });
              },
            ),
            const Expanded(
              child: Text(
                'I accept the terms and conditions.',
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _canBookTicket() {
    return _acceptedTerms &&
        _nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty;
  }

  void _bookTicket(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference ticketRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookings')
            .doc('47I0OmbSphjXOOMW4ISx')
            .collection('tickets')
            .doc();

        String ticketId = ticketRef.id;

        await ticketRef.set({
          'ticketId': ticketId,
          'trainName': widget.trainName,
          'trainNumber': widget.trainNumber,
          'passengerName': _nameController.text,
          'passengerAge': _ageController.text,
          'berthPreference': widget.berthPreference,
          'coachNumber': _generateRandomCoachNumber(''),
          'seatNumber': _generateRandomSeatNumber(),
          'toStation': widget.toStation,
          'travelDate': widget.travelDate,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TicketPage(
              ticketId: ticketId,
              trainName: widget.trainName,
              trainNumber: widget.trainNumber,
              passengerName: _nameController.text,
              passengerAge: _ageController.text,
              berthPreference: widget.berthPreference,
              toStation: widget.toStation,
              travelDate: widget.travelDate,
            ),
          ),
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

  String _generateRandomCoachNumber(String preferredCoach) {
    List<String> coachList = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    Random random = Random();
    if (preferredCoach.isNotEmpty && coachList.contains(preferredCoach)) {
      return preferredCoach;
    } else {
      return coachList[random.nextInt(coachList.length)];
    }
  }

  String _generateRandomSeatNumber() {
    Random random = Random();
    return (random.nextInt(60) + 1).toString();
  }
}
