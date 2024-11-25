import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Profile'),
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
              _buildHealthSummaryCard(),
              const SizedBox(height: 16),
              _buildUpcomingAppointmentsCard(),
              const SizedBox(height: 16),
              _buildRecentVitalsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.favorite, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Health Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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

  Widget _buildUpcomingAppointmentsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAppointment(
              'General Checkup',
              'Dr. Kimemia',
              'Tomorrow, 10:00 AM',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointment(String type, String doctor, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(type),
      subtitle: Text(doctor),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVitalsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.show_chart, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Recent Vitals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildVitalCard('Blood Pressure', '120/80', 'mmHg'),
                  const SizedBox(width: 12),
                  _buildVitalCard('Heart Rate', '72', 'bpm'),
                  const SizedBox(width: 12),
                  _buildVitalCard('Temperature', '36.6', '°C'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(String title, String value, String unit) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class USSDHome extends StatefulWidget {
  const USSDHome({super.key});

  @override
  USSDHomeState createState() => USSDHomeState();
}

class USSDHomeState extends State<USSDHome> {
  String responseText = '';
  bool isLoading = false;

  static const String ussdApiUrl = 'https://your-ussd-gateway.com/api/send';
  static const String apiKey = 'your_api_key';

  Future<void> sendUSSD(String ussdCode) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      responseText = 'Processing your request...';
    });

    try {
      final response = await http
          .post(
            Uri.parse(ussdApiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode({'ussd_code': ussdCode}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          responseText = data['message'] ?? 'No response message from server';
        });
      } else {
        setState(() {
          responseText =
              'Error: ${response.statusCode}\n${data['error'] ?? 'Unknown error'}';
        });
      }
    } catch (e) {
      setState(() {
        responseText = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildUSSDButton({
    required String label,
    required String code,
    required IconData icon,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: Colors.teal),
          title: Text(label),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: isLoading ? null : () => sendUSSD(code),
          enabled: !isLoading,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meku USSD'),
        elevation: 2,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a Service:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              buildUSSDButton(
                label: 'Register',
                code: '*123*1#',
                icon: Icons.person_add,
                subtitle: 'Create your healthcare account',
              ),
              buildUSSDButton(
                label: 'Log Vitals',
                code: '*123*2#',
                icon: Icons.favorite,
                subtitle: 'Record blood pressure, temperature, etc.',
              ),
              buildUSSDButton(
                label: 'Book Appointment',
                code: '*123*3#',
                icon: Icons.calendar_today,
                subtitle: 'Schedule a consultation',
              ),
              buildUSSDButton(
                label: 'Change Language',
                code: '*123*4#',
                icon: Icons.language,
                subtitle: 'Switch application language',
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'System Response:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: isLoading
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Processing request...'),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                child: Text(
                                  responseText,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
