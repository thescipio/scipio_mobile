import 'package:flutter/material.dart';

class IssueDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String device;
  final String date;

  const IssueDetailPage({
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
          title,
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IssueHeader(
              author: author,
              device: device,
              date: date,
            ),
            const SizedBox(height: 16),
            const IssueDetail(),
            const SizedBox(height: 16),
            const CommentSection(),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            const AddCommentSection(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: colorScheme.secondary,
                child: const Icon(Icons.send),
              ),
            ),
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
  const IssueDetail({super.key});

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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Google photo keeps crashing while connecting to a wifi Edited',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

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
        Container(
          padding: const EdgeInsets.all(16),
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
                  Text('zoro', style: TextStyle(color: colorScheme.onSurface)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'SS bug bhai',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                'Feb 3, 2025',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddCommentSection extends StatelessWidget {
  const AddCommentSection({super.key});

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
      ],
    );
  }
}
