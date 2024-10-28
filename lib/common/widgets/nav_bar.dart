import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onSelectPage;

  const CustomNavBar({
    super.key,
    required this.currentPage,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Container(
      width: double.infinity,
      height: isTablet ? 90 : 78,
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32, bottom: 8),
      decoration: const ShapeDecoration(
        color: Color(0xFFF2F2F2),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFE4E4E4)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(context, Icons.home, 0, isTablet, 'Início'),
          _buildNavItem(context, Icons.list, 1, isTablet, 'Distâncias'),
          _buildCenterItem(context, 2, isTablet),
          _buildNavItem(context, Icons.info, 3, isTablet, 'Sobre'),
          _buildNavItem(context, Icons.message, 4, isTablet, 'Feedback'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index,
      bool isTablet, String label) {
    return Semantics(
      label: label,
      hint:
          'Botão do menu, no momento ${currentPage == index ? "selecionado" : "não selecionado"}',
      button: true,
      child: GestureDetector(
        onTap: () => onSelectPage(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTablet ? 28 : 24,
              height: isTablet ? 28 : 24,
              decoration: BoxDecoration(
                color:
                    currentPage == index ? Colors.purple : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isTablet ? 28 : 24,
                color: currentPage == index ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: ShapeDecoration(
                color: currentPage == index
                    ? const Color(0xFFEFDF58)
                    : const Color(0xFFA2A2A2),
                shape: const OvalBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterItem(BuildContext context, int index, bool isTablet) {
    return Semantics(
      label: 'Mapa interativo',
      hint:
          'Botão central do menu, no momento ${currentPage == index ? "selecionado" : "não selecionado"}',
      button: true,
      child: GestureDetector(
        onTap: () => onSelectPage(index),
        child: Container(
          width: isTablet ? 70 : 60,
          height: isTablet ? 70 : 60,
          decoration: ShapeDecoration(
            color:
                currentPage == index ? Colors.purple : const Color(0xFFC6C6C6),
            shape: const CircleBorder(),
          ),
          child: Icon(
            Icons.location_on_outlined,
            size: isTablet ? 48 : 40,
            color: currentPage == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
