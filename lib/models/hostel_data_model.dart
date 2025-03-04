import 'package:ekawi/models/application_data.dart';

class HostelData {
  final double currentUsage;
  final double lastMonth;
  final double dailyAverage;
  final double occupancy;
  final double savings;
  final int floors;
  final List<ApplianceDataModel> appliances;

  HostelData({
    required this.currentUsage,
    required this.lastMonth,
    required this.dailyAverage,
    required this.occupancy,
    required this.savings,
    required this.floors,
    required this.appliances,
  });
}