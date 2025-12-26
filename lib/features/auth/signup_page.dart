import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;

  final Color weboColor = const Color(0xFF00A3B4);
  final Color detailColor = const Color(0xFF0097B2);

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (emailCtrl.text.trim().isEmpty || passCtrl.text.trim().isEmpty) {
      showMsg("Preencha todos os campos.");
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      
      if (!mounted) return;
      showMsg("Conta criada com sucesso!", isError: false);
      Navigator.pop(context); // Volta para a tela de login
    } on FirebaseAuthException catch (e) {
      String msg = "Erro ao cadastrar.";
      if (e.code == 'weak-password') msg = "A senha é muito fraca.";
      if (e.code == 'email-already-in-use') msg = "Este e-mail já está em uso.";
      if (e.code == 'invalid-email') msg = "E-mail inválido.";
      showMsg(msg);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void showMsg(String text, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration customInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: detailColor, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: detailColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: detailColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Criar Conta', style: TextStyle(color: Colors.white)),
        backgroundColor: weboColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset('assets/images/logo3.png', width: 100),
              const SizedBox(height: 40),
              TextField(
                style: const TextStyle(color: Colors.black87),
                controller: emailCtrl, decoration: customInput('Email', Icons.email_outlined)),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.black87),
                controller: passCtrl, obscureText: true, decoration: customInput('Senha', Icons.lock_outline)),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: weboColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isLoading ? null : signup,
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Cadastrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}