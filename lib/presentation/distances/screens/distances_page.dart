import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigacidades/presentation/distances/bloc/distances_bloc.dart';
import 'package:sigacidades/presentation/distances/bloc/distances_event.dart';
import 'package:sigacidades/presentation/distances/bloc/distances_state.dart';
import 'package:sigacidades/presentation/distances/widgets/place_distance_widget.dart';
import 'package:sigacidades/domain/repositories/place_repository.dart';
import 'package:sigacidades/domain/entities/place.dart';
import 'package:sigacidades/presentation/place/screens/place_page.dart';

class DistancesPage extends StatelessWidget {
  static const routeName = '/distances';

  const DistancesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    double horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    double titleFontSize = isDesktop ? 16 : (isTablet ? 18 : 16);
    double buttonFontSize = isDesktop ? 18 : 16;
    double spacingBetweenItems = isDesktop ? 24 : 16;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Semantics(
            header: true,
            child: Text(
              'Locais próximos',
              style: TextStyle(
                color: const Color(0xFF080808),
                fontSize: titleFontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: spacingBetweenItems),
          Expanded(
            child: BlocProvider(
              create: (context) =>
                  DistancesBloc(context.read<PlaceRepository>())
                    ..add(FetchNearbyPlacesEvent()),
              child: BlocBuilder<DistancesBloc, DistancesState>(
                builder: (context, state) {
                  if (state is DistancesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DistancesPermissionRequired ||
                      state is DistancesError) {
                    String message = state is DistancesPermissionRequired
                        ? state.message
                        : (state is DistancesError
                            ? state.message
                            : "Ocorreu um erro inesperado.");

                    return Center(
                      child: Semantics(
                        label: 'Erro ao carregar locais próximos: $message',
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<DistancesBloc>()
                                      .add(FetchNearbyPlacesEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                child: Text(
                                  'Tentar Novamente',
                                  style: TextStyle(
                                    fontSize: buttonFontSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is DistancesLoaded) {
                    final nearbyPlaces = state.nearbyPlacesWithDistances;

                    return ListView.builder(
                      itemCount: nearbyPlaces.length,
                      itemBuilder: (context, index) {
                        final placeData = nearbyPlaces[index];
                        final place = placeData['place'] as Place;
                        final distance = placeData['distance'] as double;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacePage(place: place),
                              ),
                            );
                          },
                          child: PlaceDistanceWidget(
                            place: place,
                            distance: distance,
                            isTablet: isTablet,
                            isDesktop: isDesktop,
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
