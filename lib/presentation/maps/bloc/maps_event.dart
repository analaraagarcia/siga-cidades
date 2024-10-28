import 'package:equatable/equatable.dart';

// ====================================
// Classe abstrata MapsEvent
// ====================================
// Define a base para todos os eventos que o MapsBloc pode lidar.
// Usamos Equatable para facilitar a comparação entre eventos.
abstract class MapsEvent extends Equatable {
  const MapsEvent();

  @override
  List<Object?> get props => [];
}

// ====================================
// Evento LoadUserLocationAndPlaces
// ====================================
// Este evento é disparado quando queremos carregar a localização do usuário
// e os lugares próximos no MapsBloc.
class LoadUserLocationAndPlaces extends MapsEvent {}
