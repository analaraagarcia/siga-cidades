import 'package:flutter/material.dart';
import 'package:sigacidades/domain/entities/place.dart';

Widget placeCard(Place place, bool isDesktop) {
  final double imageHeight = isDesktop ? 200.0 : 100.0;

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0.5,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),

        // Título com FittedBox para ajustar automaticamente o tamanho
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              place.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF474747),
                fontSize: isDesktop ? 18 : 12,
                fontFamily: 'Sora',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Exibe a imagem do lugar com descrição para acessibilidade
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          child: Semantics(
            label: 'Imagem do lugar: ${place.name}. ${place.imageDescription}',
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                place.imageUrl,
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
