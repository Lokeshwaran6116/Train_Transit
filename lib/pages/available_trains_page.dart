import 'package:flutter/material.dart';
import 'dart:math';
import 'package:train_transit/pages/payment_page.dart'; // Replace with the correct import for PaymentPage

class AvailableTrainsPage extends StatelessWidget {
  final List<Map<String, String>> trains = [
    {
      'trainNumber': '12638',
      'trainName': 'Pandian Express',
      'destination': 'Chennai Egmore'
    },
    {
      'trainNumber': '12636',
      'trainName': 'Vaigai Superfast Express',
      'destination': 'Chennai Egmore'
    },
    {
      'trainNumber': '22668',
      'trainName': 'Madurai Chennai Egmore SF Express',
      'destination': 'Chennai Egmore'
    },
    {
      'trainNumber': '12662',
      'trainName': 'Pothigai Express',
      'destination': 'Chennai Egmore'
    },
  ];

  final String toStation;
  final String travelDate;

  AvailableTrainsPage({
    required this.toStation,
    required this.travelDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Trains'),
      ),
      body: ListView.builder(
        itemCount: trains.length,
        itemBuilder: (context, index) {
          final train = trains[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Train Number: ${train['trainNumber']}',
                        style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Train Name: ${train['trainName']}',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Destination: ${train['destination']}',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      SizedBox(height: 16.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            AvailableClassWidget(
                              className: 'AC 1 Tier',
                              availability: 50,
                              onTap: () {
                                if (50 > 0) {
                                  _showBookTicketDialog(context, train['trainNumber']!, train['trainName']!, 'AC 1 Tier', '50');
                                } else {
                                  _showClassAvailabilityDialog(context, 'AC 1 Tier', '50');
                                }
                              },
                            ),
                            SizedBox(width: 8.0),
                            AvailableClassWidget(
                              className: 'AC 2 Tier',
                              availability: 30,
                              onTap: () {
                                if (30 > 0) {
                                  _showBookTicketDialog(context, train['trainNumber']!, train['trainName']!, 'AC 2 Tier', '30');
                                } else {
                                  _showClassAvailabilityDialog(context, 'AC 2 Tier', '30');
                                }
                              },
                            ),
                            SizedBox(width: 8.0),
                            AvailableClassWidget(
                              className: 'AC 3 Tier',
                              availability: 100,
                              onTap: () {
                                if (100 > 0) {
                                  _showBookTicketDialog(context, train['trainNumber']!, train['trainName']!, 'AC 3 Tier', '100');
                                } else {
                                  _showClassAvailabilityDialog(context, 'AC 3 Tier', '100');
                                }
                              },
                            ),
                            SizedBox(width: 8.0),
                            AvailableClassWidget(
                              className: 'Sleeper',
                              availability: 80,
                              onTap: () {
                                if (80 > 0) {
                                  _showBookTicketDialog(context, train['trainNumber']!, train['trainName']!, 'Sleeper', '80');
                                } else {
                                  _showClassAvailabilityDialog(context, 'Sleeper', '80');
                                }
                              },
                            ),
                            SizedBox(width: 8.0),
                            AvailableClassWidget(
                              className: '2S',
                              availability: 20,
                              onTap: () {
                                if (20 > 0) {
                                  _showBookTicketDialog(context, train['trainNumber']!, train['trainName']!, '2S', '20');
                                } else {
                                  _showClassAvailabilityDialog(context, '2S', '20');
                                }
                              },
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
        },
      ),
    );
  }

  void _showClassAvailabilityDialog(BuildContext context, String className, String availability) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Availability in $className'),
          content: Text('Seats Available: $availability'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showBookTicketDialog(BuildContext context, String trainNumber, String trainName, String className, String availability) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Book Ticket'),
          content: Text('Would you like to book a ticket for $className?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToPaymentPage(context, trainNumber, trainName, className);
              },
              child: Text('Book'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPaymentPage(BuildContext context, String trainNumber, String trainName, String className) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          trainNumber: trainNumber,
          trainName: trainName,
          berthPreference: className,
          passengerName: '', // Initialize with empty or default values
          passengerAge: '',
          toStation: toStation,
          travelDate: travelDate,
        ),
      ),
    );
  }
}

class AvailableClassWidget extends StatelessWidget {
  final String className;
  final int availability;
  final VoidCallback onTap;

  const AvailableClassWidget({
    required this.className,
    required this.availability,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: availability > 0 ? Colors.green[200] : Colors.red[200],
        ),
        child: Column(
          children: [
            Text(
              className,
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            SizedBox(height: 4.0),
            Text(
              'Available: $availability',
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
            if (availability > 0) ...[
              SizedBox(height: 4.0),
              Text(
                'Tap to book',
                style: TextStyle(color: Colors.black, fontSize: 12.0),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
