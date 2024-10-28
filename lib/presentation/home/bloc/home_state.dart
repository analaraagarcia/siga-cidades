import 'package:equatable/equatable.dart';
import 'package:sigacidades/domain/entities/place.dart';

// A base da arquitetura limpa é a separação das responsabilidades.
// Neste arquivo temos os estados que o BLoC vai emitir conforme a página muda de estado.
// Uso de equatable facilita as comparações entre os estados, melhorando performance do BLoC.

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

// Estado de carregamento.
// Quando o BLoC está obtendo dados (como ao buscar lugares), este estado é emitido.
class CategoryLoading extends CategoryState {}

// Estado de sucesso no carregamento dos dados.
// O CategoryLoaded mantém os lugares filtrados com base na categoria e cidade selecionada.
class CategoryLoaded extends CategoryState {
  final int selectedIndex; // Índice da categoria selecionada.
  final List<Place> filteredPlaces; // Lista dos lugares filtrados.

  const CategoryLoaded({
    required this.selectedIndex,
    required this.filteredPlaces,
  });

  @override
  List<Object?> get props => [selectedIndex, filteredPlaces];
}

// Estado de erro.
// Quando ocorre algum problema, como uma falha ao carregar os lugares, emite esse estado.
class CategoryError extends CategoryState {
  final String message; // Mensagem de erro.

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
