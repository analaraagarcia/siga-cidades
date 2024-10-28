import 'package:equatable/equatable.dart';

// ====================================
// Eventos do BLoC de distâncias
// ====================================
abstract class DistancesEvent extends Equatable {
  const DistancesEvent();

  @override
  List<Object> get props => [];
}

// Evento para buscar os lugares mais próximos
class FetchNearbyPlacesEvent extends DistancesEvent {}
