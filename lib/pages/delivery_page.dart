import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:train_transit/components/loc_book.dart';
import 'package:train_transit/pages/passenger_details_page.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  DateTime? start;
  DateTime? end;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  // List of train stations between Chennai and Madurai
  List<String> trainStations = [
    'Chennai Egmore',
    'Tambaram',
    'Chengalpattu Junction',
    'Villupuram Junction',
    'Tiruchirappalli Junction',
    'Dindigul Junction',
    'Madurai Junction',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.blueAccent,
                            secondary: const Color.fromARGB(255, 95, 122, 169),
                          ),
                          buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (result != null) {
                    setState(() {
                      start = result.start;
                      end = result.end;
                    });
                  }
                },
                child: const Text("Select Date Range"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white, // Change the text color here
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  start != null ? DateFormat('dd-MM-yyyy').format(start!) : "-",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(width: 8),
                const Text(
                  "to",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(width: 8),
                Text(
                  end != null ? DateFormat('dd-MM-yyyy').format(end!) : "-",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (start != null && end != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerDetailsPage(
                          startDate: start!,
                          endDate: end!,
                          fromStation: fromController.text.trim(),
                          toStation: toController.text.trim(),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a date range')),
                    );
                  }
                },
                child: const Text("Search Passengers"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
