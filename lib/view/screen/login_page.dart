import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:scipio/view/screen/dashboard_page.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio();
  bool _isOtpRequested = false;
  String _savedUsername = '';

  Future<void> _requestOtp() async {
    final String username = _usernameController.text.trim();
    if (username.isEmpty) return;

    try {
      await _dio.post('https://canna.hlcyn.co/api/passkey/$username');
      setState(() {
        _isOtpRequested = true;
        _savedUsername = username;
      });
    } catch (e) {
      _showSnackBar('Failed to request OTP');
    }
  }

  Future<void> _login() async {
    final String passkeyStr = _passwordController.text.trim();
    if (passkeyStr.isEmpty) return;

    final int? passkey = int.tryParse(passkeyStr);
    if (passkey == null) {
      _showSnackBar('Invalid passkey format');
      return;
    }

    try {
      final requestData = {
        'username': _savedUsername,
        'passkey': passkey,
      };

      final response = await _dio.post(
        'https://canna.hlcyn.co/api/auth',
        data: json.encode(requestData),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;
      if (data["token"] != null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data["token"]);
        _showSnackBar('Login successful');
        
        // Arahkan ke Dashboard setelah login sukses
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        _showSnackBar('Login failed');
      }
    } catch (e) {
      _showSnackBar('Login failed');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: _isOtpRequested
                      ? _passwordController
                      : _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surfaceVariant,
                    hintText: _isOtpRequested ? 'Passkey' : 'Username',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: _isOtpRequested,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isOtpRequested ? _login : _requestOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isOtpRequested ? 'Login' : 'Request OTP',
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Please contact @Hanabichanbot on Telegram to create your account',
                style:
                    TextStyle(color: colorScheme.onBackground.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
