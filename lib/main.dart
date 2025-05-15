import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Seguro',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blueGrey),
      home: const MyHomePage(title: "Página de Login"),
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> simulateLogin(String email, String password) async {
    // Simulando o login: se a senha for "123456", retorna o token "abc123"
    if (password == 'ArianeKedma') {
      return 'abc123'; // Token fictício
    }
    return null; // Login falhou
  }

  void _simulateLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Simulando a chamada de login
      final token = await simulateLogin(email, password);
      if (token != null) {
        // Armazenando o token de forma segura
        await storage.write(key: 'token', value: token);

        // Exibindo a mensagem de sucesso
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login realizado com sucesso!')));
      } else {
        // Se o login falhar, exibe uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha no login. Verifique suas credenciais.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Digite um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: ' Senha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)
                    ),
                  obscureText: true,
                  validator: (value) =>
                  (value != null && value.isNotEmpty) 
                  ? null
                  : 'Informe a senha',
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _simulateLogin,
                  icon: const Icon(Icons.login),
                  label: const Text('Entrar'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
