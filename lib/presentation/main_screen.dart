import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigacidades/common/widgets/app_search_bar.dart';
import 'package:sigacidades/common/widgets/nav_bar.dart';
import 'package:sigacidades/common/widgets/desktop_nav_bar.dart';
import 'package:sigacidades/common/widgets/drawer_menu.dart';
import 'package:sigacidades/presentation/home/screens/home_page.dart';
import 'package:sigacidades/presentation/distances/screens/distances_page.dart';
import 'package:sigacidades/presentation/maps/screens/maps_page.dart';
import 'package:sigacidades/presentation/about/screens/about_page.dart';
import 'package:sigacidades/presentation/feedback/screens/feedback_page.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Controla a página atual que foi selecionada no IndexedStack (definido na seção conteúdo dinâmico)
  int _selectedIndex = 0;

  // Cidade atualmente selecionada para ser usada no AppSearchBar
  String? selectedCity;

  // Lista com todas as páginas que serão carregadas dinamicamente
  final List<Widget> _pages = [
    const HomePage(),
    const DistancesPage(),
    const MapsPage(),
    const AboutPage(),
    const FeedbackPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // GlobalKey para o controle do Drawer
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    // Pega as dimensões da tela
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Espaçamento e dimensões configurados de acordo com o tipo de dispositivo
    double paddingHorizontal = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    double topPadding = isDesktop ? -60 : (isTablet ? 56 : 47);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF2F2F2),

      // ====================================
      // Seção: Drawer Menu
      // ====================================
      drawer: DrawerMenu(
        onCitySelected: (city) {
          // Atualiza a cidade selecionada na MainScreen
          setState(() {
            selectedCity = city; // Atualiza a cidade para o AppSearchBar
          });
          // Usamos aqui o Semantics por questões de acessibilidade ao selecionar a cidade do drawer
          // SemanticsService é usada em contexto global
          // A cidade será lida pelo leitor de tela sem precisar ser inserido em um contexto de algum widget específico.

          // SemanticsService.announce(
          //   'Cidade selecionada: $city',
          //   TextDirection.ltr,
          // );
        },
      ),

      // ====================================
      // Seção: CustomDesktopNavBar com Barra de Busca para Desktop
      // ====================================
      body: Column(
        children: [
          if (isDesktop)
            CustomDesktopNavBar(
              currentPage: _selectedIndex,
              onSelectPage: (index) {
                setState(() {
                  _selectedIndex = index; // Atualiza a página selecionada
                });
              },
              onMenuTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              selectedCity: selectedCity,
            ),
          Expanded(
            child: Stack(
              children: [
                // ====================================
                // Seção: App Search Bar para Tablet e Mobile
                // ====================================
                if (!isDesktop)
                  Positioned(
                    top: topPadding,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: paddingHorizontal),
                      child: AppSearchBar(
                        onMenuTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        placeRepository:
                            context.read(), // Repositório de locais
                        selectedCity:
                            selectedCity, // Passa a cidade selecionada
                      ),
                    ),
                  ),

                // ====================================
                // Seção: Linha divisória abaixo da barra de busca
                // ====================================
                Positioned(
                  top: topPadding + 64, // Alinha logo abaixo da AppSearchBar
                  left: paddingHorizontal,
                  right: paddingHorizontal,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: const Color(0xFFE4E4E4),
                      ),
                      const SizedBox(height: 16), // Espaçamento depois da linha
                    ],
                  ),
                ),

                // ====================================
                // Seção: Conteúdo dinâmico
                // ====================================
                Positioned(
                  top: topPadding +
                      65, // Alinha o conteúdo após a linha divisória e o padding
                  left: 0,
                  right: 0,
                  bottom: 0,
                  // Aqui temos a IndexedStack que carrega as páginas da lista e passa o index da página selecionada
                  child: IndexedStack(
                    index: _selectedIndex, // Carrega a página selecionada
                    children: _pages, // Carrega todas as páginas
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ====================================
      // Seção: Barra de Navegação Inferior (CustomNavBar) em Dispositivos Móveis e Tablet
      // ====================================
      bottomNavigationBar: isDesktop
          ? null // Ocultar barra de navegação em desktop
          : CustomNavBar(
              currentPage: _selectedIndex,
              onSelectPage: (index) {
                setState(() {
                  _selectedIndex =
                      index; // Aqui recebemos o index da página e fazemos a atualização da página selecionada na NavBar pelo usuário
                });
              },
            ),
    );
  }
}
