// Template em HTML para enviar o feedback por e-mail
String generateFeedbackEmailHTML(
    String name, String email, String message, String device) {
  return '''
  <html>
    <body style="font-family: 'Poppins', Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center" style="padding: 20px;">
            <table class="content" width="600" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse; border: 1px solid #cccccc; background-color: #ffffff;">
              
              <!-- Header -->
              <tr>
                <td class="header" style="background-color: #9b59b6; padding: 40px; text-align: center; color: white; font-size: 24px;">
                  Feedback do Siga Cidades.
                </td>
              </tr>

              <!-- Corpo do e-mail -->
              <tr>
                <td class="body" style="padding: 40px; text-align: left; font-size: 16px; line-height: 1.6; color: #333333;">
                  <h5>Você recebeu um novo feedback enviado através do aplicativo <strong>Siga Cidades</strong>.</h5>
                  <br>
                  <p><strong>Nome do usuário:</strong> $name</p>
                  <p><strong>E-mail:</strong> $email</p>
                  <p><strong>Dispositivo de origem:</strong> $device</p>
                  <p><strong>Mensagem:</strong></p>
                  <p>$message</p>
                </td>
              </tr>

              <!-- Call to action para responder o e-mail -->
              <tr>
                <td style="padding: 20px; text-align: center;">
                  <table cellspacing="0" cellpadding="0">
                    <tr>
                      <td align="center" style="background-color: #9b59b6; padding: 10px 20px; border-radius: 5px;">
                        <a href="mailto:$email" style="color: #ffffff; text-decoration: none; font-weight: bold;">Responder e-mail</a>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

              <!-- Rodapé -->
              <tr>
                <td class="footer" style="background-color: #333333; padding: 40px; text-align: center; color: white; font-size: 14px;">
                  <p>Este e-mail foi gerado automaticamente pelo sistema de feedback do <strong>Siga Cidades</strong>.</p>
                  <p>&copy; Biblioteca Falada. Todos os direitos reservados.</p>
                </td>
              </tr>

            </table>
          </td>
        </tr>
      </table>
    </body>
  </html>
  ''';
}
