import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  String? selectedDevice;
  String? selectedVersion;
  List<Map<String, String>> devices = [];
  List<Map<String, String>> versions = [];

  @override
  void initState() {
    super.initState();
    fetchDevices();
    fetchVersions();
  }

  Future<void> fetchDevices() async {
    try {
      final response = await Dio().get('http://canna.hlcyn.co/api/device');
      setState(() {
        devices = (response.data['data'] as List)
            .map((e) => {
                  'marketname': e['marketname'].toString(),
                  'codename': e['codename'].toString()
                })
            .toList();
      });
    } catch (e) {
      print('Failed to load devices: $e');
    }
  }

  Future<void> fetchVersions() async {
    try {
      final response = await Dio().get('http://canna.hlcyn.co/api/version');
      setState(() {
        versions = (response.data['data'] as List)
            .map((e) => {
                  'branch': e['branch'].toString(),
                  'codename': e['codename'].toString()
                })
            .toList();
      });
    } catch (e) {
      print('Failed to load versions: $e');
    }
  }

  Future<void> submitIssue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print('No auth token found');
        return;
      }

      final requestBody = {
        'title': titleController.text,
        'device': selectedDevice ?? '',
        'version': selectedVersion ?? '',
        'description': detailController.text,
        'attachment_link': linkController.text,
      };

      final response = await Dio().post(
        'https://canna.hlcyn.co/api/issue',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: requestBody,
      );
      print('Issue submission response: ${response.data}');

  
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Failed to submit issue: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Report New Issue', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 24),
              CustomTextField(controller: titleController, hintText: 'Title'),
              const SizedBox(height: 16),
              CustomDropdown(
                value: selectedDevice,
                items: devices,
                hintText: 'Device',
                onChanged: (value) => setState(() => selectedDevice = value),
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                value: selectedVersion,
                items: versions,
                hintText: 'Version',
                onChanged: (value) => setState(() => selectedVersion = value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: detailController,
                  hintText: 'Describe the issue...',
                  maxLines: 5),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: linkController, hintText: 'Attachment Link'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitIssue,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<Map<String, String>> items;
  final String hintText;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e['branch'] ?? e['codename'],
                child: Text(e['marketname'] ?? e['branch'] ?? ''),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}
