import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class UserSecureScreen extends StatefulWidget {
  const UserSecureScreen({super.key});

  @override
  State<UserSecureScreen> createState() => _UserSecureScreenState();
}

class _UserSecureScreenState extends State<UserSecureScreen> {
  static const String emailKey = 'email';
  static const String passwordKey = 'password';
  static const String tokenKey = 'token';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString(emailKey) ?? '';
      _passwordController.text = prefs.getString(passwordKey) ?? '';
    });
  }

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, _emailController.text);
    await prefs.setString(passwordKey, _passwordController.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Dados salvos com sucesso!")));
  }

  Future<String?> _loginWithCredentials(String email, String password) async {
    const validEmail = 'user@example.com';
    const validPassword = 'password123';

    if (email == validEmail && password == validPassword) {
      final token = await _generateToken();
      return token;
    }
    return null;
  }

  Future<String> _generateToken() async {
    final rand = Random();
    final token =
        List.generate(32, (index) => rand.nextInt(36).toRadixString(36)).join();
    return "token_$token";
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final token = await _loginWithCredentials(email, password);

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(tokenKey, token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login realizado com sucesso! Token: $token')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha no login. Credenciais inválidas!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bem-Vindo(a)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'Digite uma senha com pelo menos 4 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _handleLogin, child: Text('Entrar')),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveUserData,
                child: Text('Salvar Dados'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
