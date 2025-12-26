import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'recover_page.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers para capturar o texto
  final emailCtrl = TextEditingController();
  final passCtrl =
      TextEditingController(); // Corrigido: antes estava usando emailCtrl para senha

  bool isLoading = false; // Controle de estado de carregamento
  final Color weboColor = const Color(0xFF00A3B4);

  @override
  void dispose() {
    // Importante limpar os controllers ao fechar a tela
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> login() async {
    // Validação simples de campos vazios
    if (emailCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
      showError("Por favor, preencha todos os campos.");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Lógica de autenticação do Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      if (!mounted) return;

      // Navegação para a Home após o sucesso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      // Tratamento de erros específicos do Firebase
      String erroPersonalizado = "Ocorreu um erro ao entrar.";

      if (e.code == 'user-not-found') {
        erroPersonalizado = "E-mail não cadastrado.";
      } else if (e.code == 'wrong-password') {
        erroPersonalizado = "Senha incorreta.";
      } else if (e.code == 'invalid-email') {
        erroPersonalizado = "Formato de e-mail inválido.";
      } else if (e.code == 'user-disabled') {
        erroPersonalizado = "Este usuário foi desativado.";
      }

      showError(erroPersonalizado);
    } catch (e) {
      showError("Erro inesperado: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Image.asset('assets/images/logo3.png', width: 120),
              const SizedBox(height: 40),

              // Campo de Email
              TextField(
                style: const TextStyle(color: Colors.black87),
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    color: Color(0xFF0097B2),
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Color(0xFF0097B2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF0097B2),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo de Senha
              TextField(
                style: const TextStyle(color: Colors.black87),
                controller: passCtrl, // Corrigido aqui
                obscureText: true, // Para esconder a senha
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: const TextStyle(
                    color: Color(0xFF0097B2),
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF0097B2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF0097B2),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botão Entrar com estado de loading
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: weboColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // Esqueci a senha
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RecoverPage()),
                  );
                },
                child: const Text(
                  'Esqueci a senha',
                  style: TextStyle(
                    color: Color(0xFF0097B2),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Criar conta
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                child: const Text(
                  'Criar conta',
                  style: TextStyle(
                    color: Color(0xFF0097B2),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
