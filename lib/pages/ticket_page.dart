import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:train_transit/pages/user_type.dart'; // Import the UserType page

class TicketPage extends StatelessWidget {
  final String ticketId;
  final String trainName;
  final String trainNumber;
  final String passengerName;
  final String passengerAge;
  final String berthPreference;
  final String preferredCoach;
  final String toStation;
  final String travelDate;

  TicketPage({
    required this.ticketId,
    required this.trainName,
    required this.trainNumber,
    required this.passengerName,
    required this.passengerAge,
    required this.berthPreference,
    this.preferredCoach = '',
    required this.toStation,
    required this.travelDate,
  });

  @override
  Widget build(BuildContext context) {
    String coachNumber = _generateRandomCoachNumber(preferredCoach);
    String seatNumber = _generateRandomSeatNumber();

    // Save ticket details to Firestore
    _saveTicketDetailsToFirestore(
      ticketId,
      trainName,
      trainNumber,
      passengerName,
      passengerAge,
      berthPreference,
      coachNumber,
      seatNumber,
      toStation,
      travelDate,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.blueGrey, width: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12.0),
              _buildTicketDetails(),
              const SizedBox(height: 12.0),
              const Divider(thickness: 1.0, color: Colors.blueGrey),
              const SizedBox(height: 12.0),
              _buildPassengerDetails(),
              const SizedBox(height: 12.0),
              _buildCoachAndSeatDetails(coachNumber, seatNumber),
              const SizedBox(height: 12.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => UserType()),
                          (route) => false,
                    );
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ticket ID: $ticketId',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          Text(
            travelDate,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ticket Details:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          _buildDetailRow('Train Name:', trainName),
          _buildDetailRow('Train Number:', trainNumber),
          _buildDetailRow('To Station:', toStation),
          _buildDetailRow(
            'Travel Date:',
            travelDate,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? style}) {
    return Row(
      children: [
        Text(
          '$label ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: style ?? const TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Passenger Details:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          _buildDetailRow('Name:', passengerName),
          _buildDetailRow('Age:', passengerAge),
        ],
      ),
    );
  }

  Widget _buildCoachAndSeatDetails(String coachNumber, String seatNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coach and Seat Details:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          _buildDetailRow('Coach Number:', coachNumber),
          _buildDetailRow('Seat Number:', seatNumber),
        ],
      ),
    );
  }

  void _saveTicketDetailsToFirestore(
      String ticketId,
      String trainName,
      String trainNumber,
      String passengerName,
      String passengerAge,
      String berthPreference,
      String coachNumber,
      String seatNumber,
      String toStation,
      String travelDate) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentReference ticketRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookings')
            .doc('47I0OmbSphjXOOMW4ISx')
            .collection('tickets')
            .doc(ticketId);

        await ticketRef.set({
          'ticketId': ticketId,
          'trainName': trainName,
          'trainNumber': trainNumber,
          'passengerName': passengerName,
          'passengerAge': passengerAge,
          'berthPreference': berthPreference,
          'coachNumber': coachNumber,
          'seatNumber': seatNumber,
          'toStation': toStation,
          'travelDate': travelDate,
        });
      } else {
        // Handle user not authenticated
        print('User not authenticated. Please log in.');
      }
    } catch (e) {
      print('Failed to save ticket details: $e');
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