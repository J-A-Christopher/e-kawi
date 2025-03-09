import 'package:ekawi/models/form_model.dart';
import 'package:ekawi/providers/energy_mgmt_provider.dart';
import 'package:ekawi/screens/dashboard_page.dart';
import 'package:ekawi/widgets/energy_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController kwhController = TextEditingController();
  DateTime? selectedDate;
  String? selectedHostelValue;
  String? selectedGadgetValue;
  final _formKey = GlobalKey<FormState>();
  FormModel formModel = FormModel(
      id: '',
      applianceName: '',
      dateFilled: DateTime.now(),
      hostelName: '',
      kwh: 0.0);

  Future<void> _showDatePicker() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2025),
                lastDate: DateTime(2030),
                onDateChanged: (DateTime? selectedDate) {
                  if (selectedDate != null) {
                    setState(() {
                      selectedDate = selectedDate;
                      dateController.text = "${selectedDate?.year}-${selectedDate?.day}-${selectedDate?.month}";
                    });

                    Navigator.pop(context);
                  }
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: DashboardPage(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Energy Audit'),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showAddDialog(),
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }

  void _showAddDialog() {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Energy Usage'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                      hint: const Text('Select Hostel To Insert Data'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select hostel';
                        }
                        return null;
                      },
                      onSaved: (String? hostelName) {
                        if (hostelName != null) {
                          formModel = FormModel(
                              id: DateTime.now().toString(),
                              applianceName: formModel.applianceName,
                              dateFilled: formModel.dateFilled,
                              hostelName: hostelName,
                              kwh: formModel.kwh);
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      items: const [
                        DropdownMenuItem(
                          value: 'HOSTEL H',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.gite,
                                color: Colors.blue,
                              ),
                              Text('HOSTEL H')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                            value: 'HOSTEL J',
                            child: Row(
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.gite,
                                  color: Colors.blue,
                                ),
                                Text('HOSTEL J')
                              ],
                            )),
                            DropdownMenuItem(
                            value: 'Soweto',
                            child: Row(
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.gite,
                                  color: Colors.blue,
                                ),
                                Text('Soweto')
                              ],
                            )),
                            DropdownMenuItem(
                            value: 'Students\' center',
                            child: Row(
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.gite,
                                  color: Colors.blue,
                                ),
                                Text('Students\' center')
                              ],
                            )),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedHostelValue = newValue;
                          });
                        }
                      }),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  DropdownButtonFormField<String>(
                      hint: const Text('Select Appliance'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an appliance';
                        }
                        return null;
                      },
                      onSaved: (String? applianceName) {
                        if (applianceName != null) {
                          formModel = FormModel(
                              id: DateTime.now().toString(),
                              applianceName: applianceName,
                              dateFilled: formModel.dateFilled,
                              hostelName: formModel.hostelName,
                              kwh: formModel.kwh);
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                      items: const [
                        DropdownMenuItem(
                          value: 'Kettle',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.local_cafe,
                                color: Colors.blue,
                              ),
                              Text('Kettle')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Phone',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.phone_android,
                                color: Colors.blue,
                              ),
                              Text('Phone')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Laptop',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.laptop,
                                color: Colors.blue,
                              ),
                              Text('Laptop')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Woofer',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.speaker,
                                color: Colors.blue,
                              ),
                              Text('Woofer')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Fluorescent Tubes',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Colors.blue,
                              ),
                              Text('Fluorescent Tubes')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Cooking Coil',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Colors.blue,
                              ),
                              Text('Cooking Coil')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Iron Box',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.iron,
                                color: Colors.blue,
                              ),
                              Text('Iron Box')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Immersion Heater',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.water_drop,
                                color: Colors.blue,
                              ),
                              Text('Immersion Heater')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Fridge',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.kitchen,
                                color: Colors.blue,
                              ),
                              Text('Fridge')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Printer',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.print,
                                color: Colors.blue,
                              ),
                              Text('Printer')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Air Conditioner',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.ac_unit,
                                color: Colors.blue,
                              ),
                              Text('Air Conditioner')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'CCTV Cameras',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.videocam,color: Colors.blue,
                              ),
                              Text('CCTV Cameras')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'TV',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.tv,
                                color: Colors.blue,
                              ),
                              Text('TV')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Blow Dry',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.air,
                                color: Colors.blue,
                              ),
                              Text('Blow Dry')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Flat Iron',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.straighten,
                                color: Colors.blue,
                              ),
                              Text('Flat Iron')
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Desktop',
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.desktop_windows,
                                color: Colors.blue,
                              ),
                              Text('Desktop')
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedGadgetValue = newValue;
                          });
                        }
                      }),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  EnergyFormField(
                    hintText: 'Enter kwH used',
                    keyboardType: TextInputType.number,
                    controller: kwhController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter kwH used';
                      }
                      return null;
                    },
                    onSaved: (String? kwh) {
                      if (kwh != null) {
                        formModel = FormModel(
                            id: DateTime.now().toString(),
                            applianceName: formModel.applianceName,
                            dateFilled: formModel.dateFilled,
                            hostelName: formModel.hostelName,
                            kwh: double.parse(kwh));
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  EnergyFormField(
                    hintText: 'Enter date',
                    isReadOnly: true,
                    onTap: _showDatePicker,
                    controller: dateController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter date';
                      }
                      return null;
                    },
                    onSaved: (String? date) {
                      if (date != null) {
                        formModel = FormModel(
                            id: DateTime.now().toString(),
                            applianceName: formModel.applianceName,
                            dateFilled: selectedDate ?? DateTime.now(),
                            hostelName: formModel.hostelName,
                            kwh: formModel.kwh);
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _submitHandler,
                child: const Text('Add'),
              ),
            ],
          );
        });
  }

  void _submitHandler() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (mounted) {
          Navigator.pop(context);
        }
        _formKey.currentState!.reset();
        await Provider.of<EnergyManagementProvider>(context, listen: false)
            .saveEnergyData(formModel);

        await Provider.of<EnergyManagementProvider>(context, listen: false)
            .getEnergyData();
        setState(() {});
      } catch (error) {
        if (mounted) {
          Navigator.pop(context);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to save energy data.Are you online?.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } else {
      return null;
    }
  }
}