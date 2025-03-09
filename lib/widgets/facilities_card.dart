import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart'; // Import Dio

class FacilitiesCard extends StatefulWidget {
  const FacilitiesCard({super.key});

  @override
  State<FacilitiesCard> createState() => _FacilitiesCardState();
}

class _FacilitiesCardState extends State<FacilitiesCard> {
  List<String> hostels = ["Hostel H & J"];
  final Dio _dio = Dio(); // Initialize Dio

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300.0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Facilities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...hostels.map((hostelName) => _buildHostelCard(hostelName)).toList(),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    _showAddFacilityDialog(context);
                  },
                  child: const Text("Add Facility"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHostelCard(String hostelName) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hostelName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, hostelName);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  onPressed: () {
                    _showAddMeterReadingDialog(context);
                  },
                  child: const Text("Add Reading"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String hostelName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete $hostelName?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  hostels.remove(hostelName);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showAddMeterReadingDialog(BuildContext context) {
    String selectedHostel = "Hostel H & J";
    TextEditingController meterReadingController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Reading"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedHostel,
                  items: hostels.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedHostel = newValue;
                    }
                  },
                  decoration: const InputDecoration(labelText: "Hostel"),
                ),
                TextField(
                  controller: meterReadingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Meter Reading"),
                ),
                Row(
                  children: [
                    Text(
                      "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          selectedDate = pickedDate;
                          (context as Element).markNeedsBuild();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final data = {
                    'hostel': selectedHostel,
                    'meterReading': meterReadingController.text,
                    'date': DateFormat('yyyy-MM-dd').format(selectedDate),
                  };
                  await _dio.post(
                    'https://beverline-5ddb2-default-rtdb.firebaseio.com/meterReadings.json',
                    data: data,
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Meter reading added successfully!')),
                  );
                } catch (e) {
                  print('Error adding meter reading: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to add meter reading.')),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _showAddFacilityDialog(BuildContext context) {
    TextEditingController hostelNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Hostel Name"),
          content: TextField(
            controller: hostelNameController,
            decoration: const InputDecoration(labelText: "Hostel Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (hostelNameController.text.isNotEmpty) {
                  setState(() {
                    hostels.add(hostelNameController.text);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}