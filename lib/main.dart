import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const IssueListScreen(),
    );
  }
}

class IssueListScreen extends StatefulWidget {
  const IssueListScreen({super.key});

  @override
  _IssueListScreenState createState() => _IssueListScreenState();
}

class _IssueListScreenState extends State<IssueListScreen> {
  late Future<List<Issue>> futureIssues;

  @override
  void initState() {
    super.initState();
    futureIssues = ApiService().fetchIssues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issues'),
      ),
      body: Center(
        child: FutureBuilder<List<Issue>>(
          future: futureIssues,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final issue = snapshot.data![index];
                  final colorScheme = Theme.of(context).colorScheme;
                  final cardColor = Color.alphaBlend(
                    colorScheme.primary.withOpacity(0.08),
                    colorScheme.surface,
                  );
                  final textColor = colorScheme.onSurface;
                  return Card(
                    margin: const EdgeInsets.all(10),
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            issue.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.person, color: textColor, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                'Author: ${issue.authorName}',
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.smartphone,
                                  color: textColor, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                'Device: ${issue.deviceParsed}',
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: textColor, size: 18),
                              const SizedBox(width: 5),
                              Text(
                                'Date: ${DateFormat.yMMMd().add_jm().format(issue.date)}',
                                style: TextStyle(color: textColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
