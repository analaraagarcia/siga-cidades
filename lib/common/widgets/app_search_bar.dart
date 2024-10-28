import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigacidades/domain/repositories/place_repository.dart';
import 'package:sigacidades/presentation/home/bloc/home_bloc.dart';
import 'package:sigacidades/presentation/home/bloc/home_state.dart';
import 'package:sigacidades/presentation/place/screens/place_page.dart';

class AppSearchBar extends StatefulWidget {
  final VoidCallback onMenuTap;
  final PlaceRepository placeRepository;
  final String? selectedCity;

  const AppSearchBar({
    super.key,
    required this.onMenuTap,
    required this.placeRepository,
    this.selectedCity,
  });

  @override
  _AppSearchBarState createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;

    // Estado da cidade selecionada
    final state = context.watch<CategoryBloc>().state;
    String selectedCity = widget.selectedCity ?? 'Bauru';
    if (state is CategoryLoaded) {
      selectedCity = context.read<CategoryBloc>().selectedCity;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Semantics(
          label: 'Botão de menu',
          hint: 'Clique para abrir o menu',
          button: true,
          child: GestureDetector(
            onTap: widget.onMenuTap,
            child: Container(
              width: isTablet ? 40 : 32,
              height: isTablet ? 40 : 32,
              alignment: Alignment.center,
              child: const Icon(Icons.menu, color: Color(0xFF080808)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Semantics(
            label: 'Campo de busca',
            hint: 'Pesquisa de locais',
            textField: true,
            child: Container(
              height: isTablet ? 64 : 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFE4E4E4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: const Color(0xFF737373),
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Pesquise por locais em $selectedCity',
                        hintStyle: TextStyle(
                          color: const Color(0xFF737373),
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Semantics(
                    label: 'Botão de busca',
                    hint: 'Clique para buscar locais',
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        _showSearchModal(
                            context, _searchController.text, selectedCity);
                      },
                      child: const Icon(Icons.search, color: Color(0xFF131313)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSearchModal(
      BuildContext context, String query, String selectedCity) async {
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite algo para pesquisar.')),
      );
      return;
    }
    final normalizedQuery = removeDiacritics(query).toLowerCase();
    final allPlaces =
        await widget.placeRepository.fetchPlacesByCity(selectedCity);
    final searchResults = allPlaces
        .where((place) => removeDiacritics(place.name.toLowerCase())
            .contains(normalizedQuery))
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Semantics(
          label: 'Resultados da pesquisa',
          hint: 'Mostrando locais encontrados para $query',
          child: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Resultados da Pesquisa para $selectedCity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (searchResults.isEmpty)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Local não encontrado',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final place = searchResults[index];
                        return ListTile(
                          title: Text(
                            place.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacePage(place: place),
                              ),
                            );
                          },
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueAccent,
                            size: 18,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
