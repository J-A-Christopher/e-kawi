import 'package:ekawi/models/form_model.dart';
import 'package:ekawi/providers/energy_mgmt_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AppliancesListCard extends StatelessWidget {


  const AppliancesListCard({super.key,});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Utilities',
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
                  }
                  if (snapShot.hasData) {
                    final energyData = snapShot.data as List<FormModel>;
                    final Map<String, double> groupedEnergy = {};
                    for (var item in energyData) {
                      if (groupedEnergy.containsKey(item.applianceName)) {
                        groupedEnergy[item.applianceName] =
                            groupedEnergy[item.applianceName]! + item.kwh;
                      } else {
                        groupedEnergy[item.applianceName] = item.kwh;
                      }
                    }

                    if (groupedEnergy.isEmpty) {
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

                    final groupedList = groupedEnergy.entries.toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupedList.length,
                      itemBuilder: (context, index) {
                        final applianceName = groupedList[index].key;
                        final totalKwh = groupedList[index].value;

                        return ListTile(
                          leading: Icon(applianceName == 'Charging'
                              ? Icons.electric_scooter
                              : applianceName == 'Kettle'
                                  ? Icons.local_cafe
                                  : applianceName == 'Cooking'
                                      ? Icons.fire_hydrant
                                      : applianceName == 'Lighting'
                                          ? Icons.lightbulb
                                          : Icons.lightbulb),
                          title: Text(applianceName),
                          subtitle: Text('Energy: $totalKwh kWh'),
                          // trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to appliance details
                          },
                        );
                      },
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
}
