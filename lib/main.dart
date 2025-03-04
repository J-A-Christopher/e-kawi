import 'package:ekawi/common/home_page.dart';
import 'package:ekawi/providers/energy_mgmt_provider.dart';
import 'package:ekawi/themes/app_theme.dart';
import 'package:ekawi/utils/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => EnergyManagementProvider()),
  ], child: EnergyManagement()));
}

class EnergyManagement extends StatefulWidget {
  const EnergyManagement({super.key});

  @override
  State<EnergyManagement> createState() => _EnergyManagementState();
}

class _EnergyManagementState extends State<EnergyManagement> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: MyBottomNavBar());
  }
}
