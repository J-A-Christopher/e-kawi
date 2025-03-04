import 'package:flutter/material.dart';

class FloorConsumptionCard extends StatelessWidget {
  final int floors;

  const FloorConsumptionCard({super.key, required this.floors});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Floor-wise Consumption',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: floors,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Floor ${index + 1}'),
                  subtitle: Text('${(index + 1) * 500} kWh'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to floor details
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}