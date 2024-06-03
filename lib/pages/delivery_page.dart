import 'package:flutter/material.dart';
import 'package:train_transit/components/loc_book.dart';
import 'package:intl/intl.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  DateTime? start;
  DateTime? end;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          ],
        ),
      ),
    );
  }
}
