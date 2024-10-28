import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sigacidades/core/utils/feedback_email_text.dart';
import 'dart:io';

class FeedbackPage extends StatefulWidget {
  static const routeName = '/feedback';

  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  static final RegExp namePattern = RegExp('[a-zA-Z]');
  static final RegExp emailPattern = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "Informe o seu nome!";
    } else if (!namePattern.hasMatch(name)) {
      return "O nome deve conter apenas letras";
    }
    return null;
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Informe o seu e-mail!";
    } else if (!emailPattern.hasMatch(email)) {
      return "E-mail inválido!";
    }
    return null;
  }

  String? _validateFeedback(String? feedback) {
    if (feedback == null || feedback.isEmpty) {
      return "Digite sua mensagem!";
    }
    return null;
  }

  Future<void> _sendEmail(String name, String email, String message) async {
    String? username = dotenv.env['EMAIL_USERNAME'];
    String? password = dotenv.env['EMAIL_PASSWORD'];

    if (username == null || password == null) {
      print("Credenciais de e-mail não carregadas corretamente.");
      return;
    }

    String device = Platform.isAndroid
        ? 'Android'
        : Platform.isIOS
            ? 'iOS'
            : 'Outro';

    final smtpServer = gmail(username, password);

    final emailMessage = Message()
      ..from = Address(username, 'Sigacidades Feedback')
      ..recipients.add('luisbernardinello@gmail.com')
      ..subject = 'Feedback enviado por $name'
      ..html = generateFeedbackEmailHTML(name, email, message, device);

    try {
      final sendReport = await send(emailMessage, smtpServer);
      print('E-mail enviado: ' + sendReport.toString());
      _showSuccessDialog();
    } on MailerException catch (e) {
      print('Erro ao enviar e-mail: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar feedback.')),
      );
    }
  }

  Future<void> _sendFeedback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String name = _nameController.text;
      final String email = _emailController.text;
      final String feedback = _feedbackController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enviando feedback...')),
      );

      await _sendEmail(name, email, feedback);

      _nameController.clear();
      _emailController.clear();
      _feedbackController.clear();
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Obrigado!'),
          content: const Text('Seu feedback foi enviado com sucesso!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    double padding = isDesktop ? 32.0 : 16.0;
    double fontSize = isDesktop ? 19 : (isTablet ? 17 : 15);
    double buttonFontSize = isDesktop ? 18 : 16;
    double fieldWidth = isDesktop ? 600 : double.infinity;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Semantics(
          label:
              "Página de feedback. Preencha os campos para enviar seu feedback",
          child: SizedBox(
            width: fieldWidth,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Envie o seu feedback:',
                    style: TextStyle(
                      color: const Color(0xFF080808),
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Campo Nome Completo
                  Semantics(
                    label: 'Campo para digitar o seu nome completo',
                    hint: 'Obrigatório. Somente letras',
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateName,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo E-mail
                  Semantics(
                    label: 'Campo para digitar o seu e-mail',
                    hint: 'Obrigatório. Informe um e-mail válido',
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateEmail,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo Mensagem
                  Semantics(
                    label: 'Campo para digitar a sua mensagem de feedback',
                    hint: 'Obrigatório. Digite sua mensagem ou sugestão',
                    child: TextFormField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        labelText: 'Mensagem',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: _validateFeedback,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão Enviar com Semantics
                  Center(
                    child: Semantics(
                      label: 'Botão enviar feedback',
                      hint: 'Clique para enviar a mensagem',
                      child: ElevatedButton(
                        onPressed: _sendFeedback,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 40 : 24, vertical: 12),
                        ),
                        child: Text(
                          'Enviar Feedback',
                          style: TextStyle(fontSize: buttonFontSize),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}
