import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigacidades/common/widgets/app_search_bar.dart';

class CustomDesktopNavBar extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onSelectPage;
  final VoidCallback onMenuTap;
  final String? selectedCity;

  const CustomDesktopNavBar({
    Key? key,
    required this.currentPage,
    required this.onSelectPage,
    required this.onMenuTap,
    required this.selectedCity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Semantics(
              label: 'Barra de pesquisa',
              hint: 'Pesquise locais',
              child: AppSearchBar(
                onMenuTap: onMenuTap,
                placeRepository: context.read(),
                selectedCity: selectedCity,
              ),
            ),
          ),
          const Spacer(flex: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavItem(context, 'Início', Icons.home, 0),
              _buildNavItem(context, 'Distâncias', Icons.list, 1),
              _buildNavItem(context, 'Mapa', Icons.map, 2),
              _buildNavItem(context, 'Sobre', Icons.info, 3),
              _buildNavItem(context, 'Feedback', Icons.message, 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String label, IconData icon, int index) {
    final bool isSelected = currentPage == index;

    return Semantics(
      label: label,
      hint:
          'Botão de navegação, no momento ${isSelected ? "selecionado" : "não selecionado"}',
      button: true,
      child: GestureDetector(
        onTap: () => onSelectPage(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(
                  icon,
                  color: isSelected ? Colors.deepPurple : Colors.grey[700],
                  size: 28,
                ),
              ),
              const SizedBox(height: 4),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.deepPurple : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: isSelected ? 24 : 0,
                color: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
