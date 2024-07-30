import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:train_transit/pages/ticket_page.dart';

class PassengerDetailsPage extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String fromStation;
  final String toStation;

  PassengerDetailsPage({
    required this.startDate,
    required this.endDate,
    required this.fromStation,
    required this.toStation,
  });

  @override
  _PassengerDetailsPageState createState() => _PassengerDetailsPageState();
}

class _PassengerDetailsPageState extends State<PassengerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Passengers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc('P56dq9oAr8YZ2GOe15xipSCq47G3') // Replace with actual user ID
            .collection('bookings')
            .doc('47I0OmbSphjXOOMW4ISx') // Replace with actual booking document ID
            .collection('tickets')
            .where('fromStation', isEqualTo: widget.fromStation)
            .where('toStation', isEqualTo: widget.toStation)
            .where('date', isGreaterThanOrEqualTo: DateFormat('dd-MM-yyyy').format(widget.startDate))
            .where('date', isLessThanOrEqualTo: DateFormat('dd-MM-yyyy').format(widget.endDate))
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No passengers found.'));
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;
              return PassengerListItem(
                ticketId: documents[index].id,
                trainName: data['trainName'],
                trainNumber: data['trainNumber'],
                passengerName: data['passengerName'],
                passengerAge: data['passengerAge'],
                berthPreference: data['berthPreference'],
                coachNumber: data['coachNumber'],
                onTap: () => _navigateToTicketPage(
                  context,
                  documents[index].id,
                  data['trainName'],
                  data['trainNumber'],
                  data['passengerName'],
                  data['passengerAge'],
                  data['berthPreference'],
                  data['coachNumber'],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToTicketPage(
      BuildContext context,
      String ticketId,
      String trainName,
      String trainNumber,
      String passengerName,
      String passengerAge,
      String berthPreference,
      String coachNumber,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketPage(
          ticketId: ticketId,
          trainName: trainName,
          trainNumber: trainNumber,
          passengerName: passengerName,
          passengerAge: passengerAge,
          berthPreference: berthPreference,
          preferredCoach: coachNumber,
          toStation: widget.toStation,
          travelDate: DateFormat('dd-MM-yyyy').format(widget.startDate),
        ),
      ),
    );
  }
}

class PassengerListItem extends StatelessWidget {
  final String ticketId;
  final String trainName;
  final String trainNumber;
  final String passengerName;
  final String passengerAge;
  final String berthPreference;
  final String coachNumber;
  final VoidCallback onTap;

  const PassengerListItem({
    required this.ticketId,
    required this.trainName,
    required this.trainNumber,
    required this.passengerName,
    required this.passengerAge,
    required this.berthPreference,
    required this.coachNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Passenger Name: $passengerName'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Age: $passengerAge'),
          Text('Coach: $coachNumber'),
          Text('PNR: $ticketId'),
        ],
      ),
      onTap: onTap,
    );
  }
}
