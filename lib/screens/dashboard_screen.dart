import 'package:doctor_helper/Screens/prescription.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class DashboardScreen extends StatefulWidget {
  final String phoneNumber;
  const DashboardScreen({super.key, required this.phoneNumber});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    print('Dashboard initialized with phone: ${widget.phoneNumber}'); // Debug print
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prescriptions'),
        automaticallyImplyLeading: false, // Prevents back button if not needed
      ),
      body: FutureBuilder<List<Prescription>>(
        future: DatabaseService.instance.getUserPrescriptions(widget.phoneNumber),
        builder: (context, snapshot) {
          print('Connection state: ${snapshot.connectionState}'); // Debug print
          print('Data: ${snapshot.data}'); // Debug print
          print('Error: ${snapshot.error}'); // Debug print

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final prescriptions = snapshot.data ?? [];
          print('Number of prescriptions: ${prescriptions.length}'); // Debug print
          
          if (prescriptions.isEmpty) {
            return const Center(
              child: Text(
                'No prescriptions yet',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = prescriptions[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(prescription.medicineName),
                  subtitle: Text(
                    'Dosage: ${prescription.dosage}\n'
                    'Duration: ${prescription.duration}\n'
                    'Date: ${prescription.date}'
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      // Delete prescription logic here
                      setState(() {
                        // This will trigger a rebuild and fetch updated data
                      });
                      // Show confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Prescription deleted'),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrescriptionScreen(phoneNumber: widget.phoneNumber),
            ),
          ).then((_) {
            // Refresh the list when returning from PrescriptionScreen
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}