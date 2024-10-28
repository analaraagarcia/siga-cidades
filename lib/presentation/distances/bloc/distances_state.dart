import 'package:equatable/equatable.dart';

// ====================================
// Estados do BLoC de distâncias
// ====================================
abstract class DistancesState extends Equatable {
  const DistancesState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class DistancesInitial extends DistancesState {}

// Estado de carregamento
class DistancesLoading extends DistancesState {}

// Estado gerado quando os lugares próximos são carregados
class DistancesLoaded extends DistancesState {
  // Lista de mapas, cada mapa possui um Place e a distância
  final List<Map<String, dynamic>> nearbyPlacesWithDistances;

  const DistancesLoaded(this.nearbyPlacesWithDistances);

  @override
  List<Object?> get props => [nearbyPlacesWithDistances];
}

// Estado para o caso em que a permissão de localização é necessária
class DistancesPermissionRequired extends DistancesState {
  final String message;

  const DistancesPermissionRequired(this.message);

  @override
  List<Object?> get props => [message];
}

// Estado de erro
class DistancesError extends DistancesState {
  final String message;

  const DistancesError(this.message);

  @override
  List<Object?> get props => [message];
}
