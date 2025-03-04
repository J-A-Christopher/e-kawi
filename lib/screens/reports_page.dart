import 'package:ekawi/providers/energy_mgmt_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../models/form_model.dart';

class EnergyDataTableScreen extends StatefulWidget {
  const EnergyDataTableScreen({super.key});

  @override
  State<EnergyDataTableScreen> createState() => _EnergyDataTableScreenState();
}

class _EnergyDataTableScreenState extends State<EnergyDataTableScreen> {
  String? selectedHostel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports.'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedHostel,
              hint: const Text('Filter Data By Hostel'),
              items: const [
                DropdownMenuItem(
                  value: 'HOSTEL H',
                  child: Text('HOSTEL H'),
                ),
                DropdownMenuItem(
                  value: 'HOSTEL J',
                  child: Text('HOSTEL J'),
                ),
              ],
              onChanged: (String? newValue) async {
                setState(() {
                  selectedHostel = newValue;
                });
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<EnergyManagementProvider>(context, listen: false)
            .getEnergyData(hostelFilter: selectedHostel),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.white, size: 40));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data!'));
          } else {
            final energyData = snapshot.data!;
            return EnergyDataTable(energyData);
          }
        },
      ),
    );
  }
}

class EnergyDataTable extends StatelessWidget {
  final List<FormModel> energyData;
  const EnergyDataTable(this.energyData, {super.key});

  @override
  Widget build(BuildContext context) {
    final totalKwh = energyData.fold(0.0, (sum, item) => sum + item.kwh);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.light;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: size.width,
        child: DataTable(
          border: TableBorder.all(
              color: theme.colorScheme.onSurface.withOpacity(0.3)),
          headingRowColor: WidgetStateColor.resolveWith(
            (states) => isDarkMode
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.secondary,
          ),
          headingTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
          dataRowHeight: 50,
          columns: const [
            DataColumn(label: Text('Usage')),
            DataColumn(label: Text('kWh')),
            DataColumn(label: Text('Date Filled')),
          ],
          rows: [
            ...energyData.map((item) {
              return DataRow(
                color: WidgetStateColor.resolveWith(
                  (states) => energyData.indexOf(item) % 2 == 0
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.surface,
                ),
                cells: [
                  DataCell(
                      Text(item.applianceName, style: TextStyle(fontSize: 14))),
                  DataCell(Text('${item.kwh.toStringAsFixed(2)} kWh',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold))),
                  DataCell(Text(
                      DateFormat('MMM dd yyyy HH:mm').format(item.dateFilled),
                      style: const TextStyle(fontSize: 14))),
                ],
              );
            }),
            DataRow(
              color: WidgetStateColor.resolveWith(
                (states) => isDarkMode
                    ? theme.colorScheme.primaryContainer.withOpacity(0.7)
                    : theme.colorScheme.secondaryContainer.withOpacity(0.8),
              ),
              cells: [
                const DataCell(Text('TOTAL',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                DataCell(Text('${totalKwh.toStringAsFixed(2)} kWh',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))),
                const DataCell(Text('')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
