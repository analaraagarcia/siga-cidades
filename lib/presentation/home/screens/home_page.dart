import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigacidades/presentation/home/bloc/home_bloc.dart';
import 'package:sigacidades/presentation/home/bloc/home_event.dart';
import 'package:sigacidades/presentation/home/bloc/home_state.dart';
import 'package:sigacidades/presentation/home/widgets/category_tag.dart';
import 'package:sigacidades/presentation/home/widgets/place_card.dart';
import 'package:sigacidades/presentation/place/screens/place_page.dart';
import 'package:sigacidades/core/utils/category_list.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;
    final double horizontalPadding = isDesktop ? 32.0 : 16.0;
    final double categoryTagWidth =
        isDesktop ? 150.0 : (isTablet ? 120.0 : 100.0);
    final int gridCrossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Título da seção "Explore"
          Semantics(
            header: true,
            child: const Text(
              'Explore',
              style: TextStyle(
                color: Color(0xFF080808),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Carrossel de categorias com acessibilidade
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              final selectedIndex =
                  (state is CategoryLoaded) ? state.selectedIndex : 0;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: ScrollController(
                  initialScrollOffset: selectedIndex * categoryTagWidth,
                ),
                child: Row(
                  children: List.generate(
                    getCategoryNames().length,
                    (index) => GestureDetector(
                      onTap: () {
                        context
                            .read<CategoryBloc>()
                            .add(SelectCategoryEvent(index));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Semantics(
                          label: 'Categoria ${getCategoryNames()[index]}'
                              '${index == selectedIndex ? ', selecionada' : ''}',
                          button: true,
                          child: categoryTag(
                            getCategoryNames()[index],
                            index == selectedIndex,
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Grid de lugares com acessibilidade
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCrossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: state.filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = state.filteredPlaces[index];

                      return Semantics(
                        label: 'Lugar: ${place.name}',
                        hint: 'Toque para ver mais detalhes',
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacePage(place: place),
                              ),
                            );
                          },
                          child: placeCard(place, isDesktop),
                        ),
                      );
                    },
                  );
                } else if (state is CategoryError) {
                  return Center(child: Text(state.message));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
