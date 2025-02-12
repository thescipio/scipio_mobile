import 'package:dio/dio.dart';

class ApiService {
  final String apiUrl = "https://canna.hlcyn.co/api/issue";
  final Dio _dio = Dio();

  Future<List<Issue>> fetchIssues() async {
    try {
      final response = await _dio.get(apiUrl);

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Issue.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load issues');
      }
    } catch (e) {
      // Log the error
      print('DioException: $e');
      throw Exception('Failed to load issues: $e');
    }
  }
}

class Issue {
  final String title;
  final String authorName;
  final String deviceParsed;
  final DateTime date;

  Issue({
    required this.title,
    required this.authorName,
    required this.deviceParsed,
    required this.date,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      title: json['title'],
      authorName: json['author_name'],
      deviceParsed: json['device_parsed'],
      date: DateTime.parse(json['date']),
    );
  }
}
