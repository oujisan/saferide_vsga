import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saferide/provider/auth_provider.dart';
import 'package:saferide/core/db_helper.dart';
import 'package:saferide/model/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    _initAndSeedUser();
  }

  Future<void> _initAndSeedUser() async {
    await _dbHelper.initDb();
    final users = await _dbHelper.getData('users');
    if (users.isEmpty) {
      await _dbHelper.insertData(
        'users',
        UserModel(
          username: 'user',
          name: 'User',
          email: 'user@example.com',
          password: 'user123',
        ).toMap(),
      );
    }
  }

  void _handleLogin(BuildContext context, AuthProvider authProvider) async {
    final success = await authProvider.login();
    if (!context.mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, '/ride');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal. Periksa username dan password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                TextField(
                  onChanged: authProvider.setUsername,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: authProvider.setPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _handleLogin(context, authProvider),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
