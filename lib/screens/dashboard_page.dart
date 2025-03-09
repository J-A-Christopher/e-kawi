import 'package:ekawi/widgets/occupancy_card.dart';
import 'package:ekawi/widgets/reusable_cards.dart';
import 'package:ekawi/widgets/widgets.dart';
import 'package:ekawi/widgets/facilities_card.dart'; // Import the FacilitiesCard
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EnergyOverviewCard(),
          const SizedBox(height: 16),
          FacilitiesCard(),
          const SizedBox(height: 16), 
          AppliancesListCard(),
          const SizedBox(height: 16),
          OccupancyCard(occupancy: 85),
          const SizedBox(height: 16),
          // Add the FacilitiesCard here
          
          // QuickActionsCard(), // If you uncomment this, add it here.
        ],
      ),
    );
  }
}