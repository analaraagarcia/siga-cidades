import 'package:equatable/equatable.dart';

// O CategoryEvent define os eventos que podem ocorrer no BLoC.
// Esses eventos representam as ações que a interface da camada de presentation envia para o BLoC processar.
abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Evento de seleção de categoria.
// Quando o usuário escolhe uma nova categoria, esse evento é enviado.
// O selectedIndex representa o índice da categoria escolhida.
class SelectCategoryEvent extends CategoryEvent {
  final int selectedIndex;

  SelectCategoryEvent(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

// Evento de seleção de cidade.
// Quando o usuário muda a cidade, esse evento é enviado para refiltrar os lugares com base na nova cidade.
class SelectCityEvent extends CategoryEvent {
  final String city;

  SelectCityEvent(this.city);

  @override
  List<Object> get props => [city];
}
