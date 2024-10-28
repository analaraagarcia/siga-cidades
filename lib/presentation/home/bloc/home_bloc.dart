import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigacidades/domain/entities/place.dart';
import 'package:sigacidades/domain/repositories/place_repository.dart';
import 'package:sigacidades/presentation/home/bloc/home_event.dart';
import 'package:sigacidades/presentation/home/bloc/home_state.dart';

/// Classe responsável pelo controle de seleção de categorias e cidades.
/// Usamos aqui o padrão Bloc de modo que exista a centralização da lógica de negócios na presentation layer
/// O Bloc então facilita o controle do estado da interface.
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final PlaceRepository
      placeRepository; // Instância do repositório de dados do Firebase
  String selectedCity = 'Bauru'; // Cidade inicial que será exibida na home page
  int currentCategoryIndex =
      0; // Categoria inicial que será exibida na home page

  // ====================================
  // Seção: Cache dos lugares filtrados
  // ====================================
  // Aqui usamos um cache para armazenar as listas de lugares para carregamento previo por cidade e categoria.
  // O cache evita inclusive que geremos consultas repetidas no Firebase para melhorar o desempenho.
  final Map<String, Map<int, List<Place>>> _placesCache = {};

  /// Construtor do Bloc, define o estado inicial do app com a categoria "Bosques e Parques".
  CategoryBloc(this.placeRepository)
      : super(CategoryLoaded(
          selectedIndex: 0, // Index inicial da categoria.
          filteredPlaces: [], // Lista de lugares inicial vazia.
        )) {
    // ====================================
    // Seção: Evento de seleção de categoria
    // ====================================
    // Fazemos a manipulação do evento SelectCategoryEvent, assim o usuário pode mudar a categoria e visualizar os lugares específicos.
    on<SelectCategoryEvent>((event, emit) async {
      currentCategoryIndex = event.selectedIndex;

      // Caso da cidade e categoria já ter sido carregadas anteriormente utiliza os dados do cache.
      if (_placesCache[selectedCity] != null &&
          _placesCache[selectedCity]!.containsKey(event.selectedIndex)) {
        emit(CategoryLoaded(
          selectedIndex: event.selectedIndex,
          filteredPlaces: _placesCache[selectedCity]![event.selectedIndex]!,
        ));
      } else {
        // Caso contrário, faz uma nova busca no Firebase para a categoria e cidade selecionadas.
        final places =
            await placeRepository.fetchPlacesByCategory(event.selectedIndex);

        // Filtramos então os lugares obtidos com base na cidade selecionada.
        final filteredPlaces =
            places.where((place) => place.city == selectedCity).toList();

        // Aqui armazenamos a lista filtrada no cache para otimização de futuras consultas.
        _placesCache.putIfAbsent(selectedCity, () => {});
        _placesCache[selectedCity]![event.selectedIndex] = filteredPlaces;

        // Emissão do estado atualizado com a lista de lugares filtrada.
        emit(CategoryLoaded(
          selectedIndex: event.selectedIndex,
          filteredPlaces: filteredPlaces,
        ));
      }
    });

    // ====================================
    // Seção: Evento de seleção de cidade
    // ====================================
    // Fazemos a manipulação do evento SelectCityEvent para atualizar a cidade selecionada.
    on<SelectCityEvent>((event, emit) async {
      selectedCity =
          event.city; // Define a nova cidade selecionada conforme o evento.

      // Evento SelectCategoryEvent adiciona novamente o carregamento dos lugares com a nova cidade atualizada
      // currentCategoryIndex mantém o filtro de lugares na mesma categoria que estava antes do usuário selecionar outra cidade.
      add(SelectCategoryEvent(currentCategoryIndex));
    });
  }
}
