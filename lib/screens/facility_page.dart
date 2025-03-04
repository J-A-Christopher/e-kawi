import 'package:flutter/material.dart';

class FacilityPage extends StatelessWidget {
  // final HostelData hostelData;

  const FacilityPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facility History Data'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text('Historical data goes here.'),
          )),
    );
  }
}
