import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecoverPage extends StatefulWidget {
  const RecoverPage({super.key});

  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  final emailCtrl = TextEditingController();
  bool isLoading = false;

  final Color weboColor = const Color(0xFF00A3B4);
  final Color detailColor = const Color(0xFF0097B2);

  Future<void> recover() async {
    if (emailCtrl.text.trim().isEmpty) {
      showMsg("Informe seu e-mail.");
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailCtrl.text.trim(),
      );
      if (!mounted) return;
      showMsg("E-mail de recuperação enviado!", isError: false);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg = "Erro ao enviar e-mail.";
      if (e.code == 'user-not-found') msg = "Usuário não encontrado.";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recuperar Senha', style: TextStyle(color: Colors.white)),
        backgroundColor: weboColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Insira seu e-mail para receber o link de redefinição",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: detailColor),
                prefixIcon: Icon(Icons.email_outlined, color: detailColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: detailColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: weboColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isLoading ? null : recover,
              child: isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Enviar Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}