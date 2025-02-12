import 'package:flutter/material.dart';

class ReportIssuePage extends StatelessWidget {
  const ReportIssuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor:
          colorScheme.background, 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start, 
            children: [
              Text(
                'Report New Issue',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  color:
                      colorScheme.onBackground, 
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              const CustomTextField(hintText: 'Title'),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Device'),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Version'),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Issue Detail',
                  style: TextStyle(
                      color: colorScheme
                          .onBackground), 
                ),
              ),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'Describe the issue...',
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Attachment Link',
                  style: TextStyle(
                      color: colorScheme
                          .onBackground), 
                ),
              ),
              const SizedBox(height: 8),
              const CustomTextField(hintText: 'Link'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      colorScheme.primary, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
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

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            color: colorScheme
                .onSurfaceVariant), 
        filled: true,
        fillColor:
            colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
          color: colorScheme.onSurface), 
    );
  }
}
