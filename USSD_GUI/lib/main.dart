import 'package:flutter/material.dart';
import 'package:health/health.dart'; // For HealthKit and Google Fit
import 'package:intl/intl.dart'; // For date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare USSD',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const USSDHome(),
    const DashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dialpad),
            label: 'USSD',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool _isWearableConnected = false;

  // Default values for metrics
  double _manualBloodPressure = 120; // Systolic
  double _manualHeartRate = 72;
  double _manualTemperature = 36.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        elevation: 2,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildWearableToggle(),
              const SizedBox(height: 20),
              _isWearableConnected
                  ? _buildHealthSummaryCard()
                  : _buildManualInputCard(),
            ],
          ),
        ),
      ),
    );
  }

  // Toggle for wearable connection
  Widget _buildWearableToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Wearable Connected:',
          style: TextStyle(fontSize: 18),
        ),
        Switch(
          value: _isWearableConnected,
          onChanged: (value) {
            setState(() {
              _isWearableConnected = value;
            });
          },
        ),
      ],
    );
  }

  // Health summary card for wearable data
  Widget _buildHealthSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Metrics (Wearables)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHealthMetric('Blood Pressure', '120/80', 'Normal'),
            const Divider(),
            _buildHealthMetric('Heart Rate', '72 bpm', 'Normal'),
            const Divider(),
            _buildHealthMetric('Temperature', '36.6°C', 'Normal'),
          ],
        ),
      ),
    );
  }

  // Manual input card
  Widget _buildManualInputCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Metrics (Manual Input)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildManualInputSlider(
              label: 'Blood Pressure (Systolic)',
              value: _manualBloodPressure,
              min: 80,
              max: 200,
              unit: 'mmHg',
              onChanged: (value) {
                setState(() {
                  _manualBloodPressure = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildManualInputSlider(
              label: 'Heart Rate',
              value: _manualHeartRate,
              min: 40,
              max: 180,
              unit: 'bpm',
              onChanged: (value) {
                setState(() {
                  _manualHeartRate = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildManualInputSlider(
              label: 'Temperature',
              value: _manualTemperature,
              min: 35,
              max: 42,
              unit: '°C',
              onChanged: (value) {
                setState(() {
                  _manualTemperature = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Slider widget for manual input
  Widget _buildManualInputSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(1)} $unit',
          style: const TextStyle(fontSize: 16),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Health metric display (shared for wearables)
  Widget _buildHealthMetric(String label, String value, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class USSDHome extends StatelessWidget {
  const USSDHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('USSD Home Placeholder'));
  }
}
