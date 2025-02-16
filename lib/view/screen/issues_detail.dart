import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class IssueDetailPage extends StatefulWidget {
  final String issueId;

  const IssueDetailPage({
    super.key,
    required this.issueId,
  });

  @override
  _IssueDetailPageState createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage> {
  final Dio _dio = Dio();
  Map<String, dynamic> _issueDetails = {};
  List<dynamic> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchIssueDetails();
    _fetchComments();
  }

  Future<void> _fetchIssueDetails() async {
    try {
      final response = await _dio
          .get('https://canna.hlcyn.co/api/issue/post/${widget.issueId}');
      if (response.statusCode == 200) {
        setState(() {
          _issueDetails = response.data['data'];
        });
      } else {
        print('Failed to load issue details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching issue details: $e');
    }
  }

  Future<void> _fetchComments() async {
    try {
      final response = await _dio
          .get('https://canna.hlcyn.co/api/comment/${widget.issueId}');
      if (response.statusCode == 200) {
        setState(() {
          _comments = response.data['data'] ?? [];
        });
      } else {
        print('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> _sendComment() async {
    final String comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');

    if (authToken == null) {
      print('No auth token found');
      return;
    }

    try {
      if (comment == "/close") {
        final response = await _dio.delete(
          'https://canna.hlcyn.co/api/issue/post/${widget.issueId}',
          options: Options(
            headers: {
              'Authorization': 'Bearer $authToken',
            },
          ),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, true);
        } else if (response.statusCode == 401) {
          _showUnauthorizedDialog();
        } else {
          print('Failed to delete issue: ${response.statusCode}');
        }
      } else {
        final response = await _dio.post(
          'https://canna.hlcyn.co/api/comment/${widget.issueId}',
          data: {'description': comment},
          options: Options(
            headers: {
              'Authorization': 'Bearer $authToken',
            },
          ),
        );

        if (response.statusCode == 200) {
          _commentController.clear();
          _fetchComments();
        } else {
          print('Failed to send comment: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error sending comment: $e');
    }
  }

  void _showUnauthorizedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unauthorized'),
          content: Text('You are unauthorized for this action!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _issueDetails['title'] ?? 'Loading...',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _issueDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IssueHeader(
                    author: _issueDetails['author_name'],
                    device: _issueDetails['device_parsed'],
                    date: _issueDetails['date'],
                  ),
                  const SizedBox(height: 16),
                  IssueDetail(
                    description: _issueDetails['description'],
                  ),
                  const SizedBox(height: 16),
                  CommentSection(comments: _comments),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  AddCommentSection(
                    commentController: _commentController,
                    onSend: _sendComment,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}

class IssueHeader extends StatelessWidget {
  final String author;
  final String device;
  final String date;

  const IssueHeader({
    super.key,
    required this.author,
    required this.device,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person, color: Colors.grey),
            const SizedBox(width: 8),
            Text(author, style: TextStyle(color: colorScheme.onBackground)),
            const SizedBox(width: 16),
            const Icon(Icons.phone_android, color: Colors.grey),
            const SizedBox(width: 8),
            Text(device, style: TextStyle(color: colorScheme.onBackground)),
          ],
        ),
        const SizedBox(height: 8),
        Text(date, style: TextStyle(color: colorScheme.onBackground)),
      ],
    );
  }
}

class IssueDetail extends StatelessWidget {
  final String description;

  const IssueDetail({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Issue Detail',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            description,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}

class CommentSection extends StatelessWidget {
  final List<dynamic> comments;

  const CommentSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...comments.map((comment) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.comment, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(comment['author_name'],
                          style: TextStyle(color: colorScheme.onSurface)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    comment['description'],
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(comment['date']),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(parsedDate);
  }
}

class AddCommentSection extends StatelessWidget {
  final TextEditingController commentController;
  final VoidCallback onSend;

  const AddCommentSection({
    super.key,
    required this.commentController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add comment',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: commentController,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surfaceVariant,
            hintText: 'Add a comment',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Type /close to close this issue (Author Only)',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: FloatingActionButton(
            onPressed: onSend,
            backgroundColor: colorScheme.secondary,
            child: const Icon(Icons.send),
          ),
        ),
      ],
    );
  }
}
