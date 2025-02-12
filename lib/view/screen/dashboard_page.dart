import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:scipio/view/screen/login_page.dart'; // Import the LoginPage

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const IssueTrackerPage(); // Display IssueTrackerPage in DashboardPage
  }
}

class IssueTrackerPage extends StatefulWidget {
  const IssueTrackerPage({super.key});

  @override
  _IssueTrackerPageState createState() => _IssueTrackerPageState();
}

class _IssueTrackerPageState extends State<IssueTrackerPage> {
  final Dio _dio = Dio();
  List<dynamic> _issues = [];

  @override
  void initState() {
    super.initState();
    _fetchIssues();
  }

  Future<void> _fetchIssues() async {
    try {
      final response = await _dio.get('https://canna.hlcyn.co/api/issue');
      if (response.statusCode == 200) {
        setState(() {
          _issues = response.data['data']; // Extract the 'data' field
        });
      } else {
        // Handle the error if the response status code is not 200
        print('Failed to load issues: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching issues: $e');
    }
  }

  // Function to format the date
  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter =
        DateFormat('MMM dd, yyyy'); // Format: Jan 30, 2025
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        title: const Text(
          'h.',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: () async {
              // Remove the auth_token from SharedPreferences
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.remove('auth_token');

              // Navigate to LoginPage after logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Issue Tracker',
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _issues.length,
                itemBuilder: (context, index) {
                  final issue = _issues[index];
                  return IssueCard(
                    title: issue['title'],
                    author: issue['author_name'],
                    device: issue['device_parsed'],
                    date: _formatDate(issue['date']), // Format the date here
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  final String title;
  final String author;
  final String device;
  final String date;

  const IssueCard({
    super.key,
    required this.title,
    required this.author,
    required this.device,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  author,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone_android, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  device,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
