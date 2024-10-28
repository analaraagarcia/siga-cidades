import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:sigacidades/core/utils/privacy_policy_text.dart';
import 'package:sigacidades/core/utils/terms_of_use_text.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about';

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    double paddingHorizontal = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    double fontSize = isDesktop ? 18 : 16;
    double buttonFontSize = isDesktop ? 16 : 14;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Sobre',
              style: TextStyle(
                color: const Color(0xFF080808),
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "O SIGA - Guia Acessível da Cidade é um aplicativo mobile que visa oferecer informações de pontos de interesse do município, como praças, ruas, avenidas, prédios, equipamentos públicos e espaços de lazer. O seu diferencial é apresentar os dados por meio de áudios com informações gerais e, principalmente, audiodescrição detalhada de aspectos físicos e estéticos de cada local, como estilo arquitetônico, características estruturais e dimensões. Cada arquivo pode ser acessado em um mapa, o que permite ao usuário relacionar os pontos de interesse e sua localização na cidade.",
              style: TextStyle(
                color: const Color(0xFF080808),
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "O aplicativo busca oferecer informação acessível e diversificada e, dessa maneira, contribuir para que as pessoas conheçam melhor a cidade e possam experienciá-la com mais autonomia e independência. Nesse sentido, tem como público preferencial (mas não exclusivo) o de pessoas com deficiência visual, principalmente porque oferece o diferencial da audiodescrição e do formato sonoro dos arquivos.",
              style: TextStyle(
                color: const Color(0xFF080808),
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "O SIGA Guia Acessível da Cidade é uma iniciativa do projeto de extensão universitária Biblioteca Falada, da Faculdade de Arquitetura, Artes, Comunicação e Design (FAAC), da Universidade Estadual Paulista “Júlio de Mesquita Filho” (Unesp), câmpus Bauru (SP). O projeto desenvolve ações no campo da acessibilidade à comunicação e à informação, em especial voltadas às pessoas com deficiência visual. Para tanto, produz mídia sonora acessível e audiodescrição, bem como atua na difusão do conhecimento sobre deficiência, tecnologias assistivas, Desenho Universal e comunicação acessível.",
              style: TextStyle(
                color: const Color(0xFF080808),
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            const Divider(color: Color(0xFFE4E4E4)),
            const SizedBox(height: 8),
            const Contacts(),
            const SizedBox(height: 15),

            // Linha divisória
            const Divider(color: Color(0xFFE4E4E4)),
            const SizedBox(height: 15),

            // Botões de Política de Privacidade e Termos de Uso
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPolicyButton(
                  context,
                  title: "Política de Privacidade",
                  onPressed: () => _showPolicyModal(
                    context,
                    "Política de Privacidade",
                    privacyPolicyText,
                  ),
                  fontSize: buttonFontSize,
                ),
                const SizedBox(width: 8),
                _buildPolicyButton(
                  context,
                  title: "Termos de Uso",
                  onPressed: () => _showPolicyModal(
                    context,
                    "Termos de Uso",
                    termsOfUseText,
                  ),
                  fontSize: buttonFontSize,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyButton(
    BuildContext context, {
    required String title,
    required VoidCallback onPressed,
    required double fontSize,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showPolicyModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        content,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get isDesktop =>
      kIsWeb ||
      (!isMobile && Platform.isLinux || Platform.isMacOS || Platform.isWindows);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Contatos',
            style: TextStyle(
              color: Color(0xFF080808),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildContactIcon(
                icon: Icons.email_outlined,
                color: Colors.purple,
                size: isMobile ? 32 : 40,
                onTap: () => _launchMail(context),
              ),
              const SizedBox(width: 21.0),
              InkWell(
                child: Text(
                  "bibliotecafalada@gmail.com",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: isMobile ? 16 : 18,
                  ),
                ),
                onTap: () => _launchMail(context),
              ),
            ],
          ),
          const SizedBox(height: 2),
          GridView.count(
            crossAxisCount: isMobile ? 2 : 4,
            shrinkWrap: true,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildGridItem(
                title: "Site Biblioteca Falada",
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/sigacidades.appspot.com/o/image%2Flogos%2Flogo_bf.png?alt=media&token=82c974cd-e14f-4b4b-b221-9ee4737f3cd3',
                onTap: () =>
                    _launchUrl(context, 'https://bibliotecafalada.unesp.br/'),
                size: size,
              ),
              _buildGridItem(
                title: "Instagram",
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/sigacidades.appspot.com/o/image%2Flogos%2Flogo_instagram.png?alt=media&token=12ee4900-0279-45f3-a62b-3660fb4fc652',
                onTap: () =>
                    _launchUrl(context, 'https://www.instagram.com/bfalada/'),
                size: size,
              ),
              _buildGridItem(
                title: "Facebook",
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/sigacidades.appspot.com/o/image%2Flogos%2Flogo_facebook.png?alt=media&token=d210d8ca-bcb4-4d93-8eeb-85710533f261',
                onTap: () => _launchUrl(
                    context, 'https://www.facebook.com/bibliotecafalada/'),
                size: size,
              ),
              _buildGridItem(
                title: "Twitter",
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/sigacidades.appspot.com/o/image%2Flogos%2Flogo_twitter.PNG?alt=media&token=6c1cf947-d622-46e9-9656-8e866b0831f8',
                onTap: () => _launchUrl(context, 'https://twitter.com/BFalada'),
                size: size,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactIcon({
    required IconData icon,
    required Color color,
    required double size,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, size: size, color: color),
    );
  }

  Widget _buildGridItem({
    required String title,
    required String imageUrl,
    required void Function() onTap,
    required Size size,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            width: size.width * 0.18,
            height: size.height * 0.15,
          ),
          AutoSizeText(
            title,
            semanticsLabel: title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: isMobile ? (size.width * 0.042) : (size.width * 0.030),
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  void _launchMail(BuildContext context) async {
    const mail = 'mailto:bibliotecafalada@gmail.com';
    if (await canLaunchUrlString(mail)) {
      await launchUrlString(mail, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Não encontrado aplicativo de envio de e-mail no dispositivo.')),
      );
    }
  }

  void _launchUrl(BuildContext context, String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }
}
