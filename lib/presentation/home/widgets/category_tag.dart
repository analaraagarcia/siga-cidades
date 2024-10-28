import 'package:flutter/material.dart';

Widget categoryTag(String label, bool isSelected,
    {double screenWidth = 360.0}) {
  double fontSize = screenWidth < 400 ? 12.0 : 14.0;
  double paddingHorizontal = screenWidth < 400 ? 8.0 : 12.0;
  double paddingVertical = screenWidth < 400 ? 6.0 : 8.0;

  return Semantics(
    label:
        'Categoria: $label, ${isSelected ? "Selecionada" : "Não selecionada"}',
    child: Container(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal, vertical: paddingVertical),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFDF58) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: const Color(0xFF080808),
          fontSize: fontSize,
          fontFamily: 'Sora',
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
