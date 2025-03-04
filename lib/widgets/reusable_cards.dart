import 'package:ekawi/models/form_model.dart';
import 'package:ekawi/providers/energy_mgmt_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class EnergyOverviewCard extends StatelessWidget {

  const EnergyOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Energy Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future:
                  Provider.of<EnergyManagementProvider>(context, listen: false)
                      .getEnergyData(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                          color: Colors.white, size: 30));
                } else if (snapShot.connectionState == ConnectionState.done) {
                  if (snapShot.hasError) {
                    return Row(
                      spacing: 3,
                      children: [
                        Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.error,
                          size: 22,
                        ),
                        Text(
                          'Error..you online?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      ],
                    );
                  } else if (snapShot.hasData) {
                    final energyData = snapShot.data as List<FormModel>;
                    final totalKiloWat = energyData.fold(
                        0.0, (sum, wattage) => sum + wattage.kwh);
                    DateTime today = DateTime.now();
                    String formattedToday =
                        DateFormat('yyyy-MM-dd').format(today);

                    List<FormModel> todayData = energyData.where((entry) {
                      String entryDate =
                          DateFormat('yyyy-MM-dd').format(entry.dateFilled);
                      return entryDate == formattedToday;
                    }).toList();

                    double totalKwh =
                        todayData.fold(0.0, (sum, item) => sum + item.kwh);
                    double averageKwh = todayData.isNotEmpty
                        ? totalKwh / todayData.length
                        : 0.0;
                    if (energyData.isEmpty) {
                      return Center(
                        child: Text('No Energy Data Available',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: _buildOverviewItem(
                            'Total Usage',
                            '${totalKiloWat.toStringAsFixed(2)} kWh'
                           
                          )
                        ),
                        Expanded(
                          child: _buildOverviewItem(
                            'Daily Average',
                            '${averageKwh.toStringAsFixed(2)} kWh',
                          
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text('No Energy Data Available',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                    );
                  }
                }
                return Center(
                  child: Text('Something went wrong.'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String title, String value,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
       
      ],
    );
  }
}
