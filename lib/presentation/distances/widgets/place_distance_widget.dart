import 'package:flutter/material.dart';
import 'package:sigacidades/domain/entities/place.dart';

class PlaceDistanceWidget extends StatelessWidget {
  final Place place;
  final double distance;
  final bool isTablet;
  final bool isDesktop;

  const PlaceDistanceWidget({
    Key? key,
    required this.place,
    required this.distance,
    required this.isTablet,
    required this.isDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardVerticalPadding = isDesktop ? 16.0 : (isTablet ? 12.0 : 8.0);
    double titleFontSize = isDesktop ? 20 : (isTablet ? 18 : 16);
    double subtitleFontSize = isDesktop ? 16 : 14;
    double distanceFontSize = isDesktop ? 18 : 16;

    return Card(
      margin:
          EdgeInsets.symmetric(vertical: cardVerticalPadding, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: cardVerticalPadding),
        child: ListTile(
          // Informações completas de acessibilidade do lugar
          title: Semantics(
            label: 'Nome do local: ${place.name}',
            child: Text(
              place.name,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Semantics(
            label:
                '${place.category}, ${place.city}, a uma distância de ${_formatDistance(distance)}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${place.category} - ${place.city}',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                  ),
                ),
                Text(
                  _formatDistance(distance),
                  style: TextStyle(
                    color: const Color(0xFFFFA500),
                    fontWeight: FontWeight.w600,
                    fontSize: distanceFontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDistance(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} metros';
    } else {
      return '${(distance / 1000).toStringAsFixed(2)} quilômetros';
    }
  }
}
