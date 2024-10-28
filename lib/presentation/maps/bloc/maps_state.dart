import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sigacidades/domain/entities/place.dart';

// Define os estados possíveis que o MapsBloc pode emitir.
abstract class MapsState extends Equatable {
  @override
  List<Object?> get props => [];
}

// ====================================
// Estado MapsLoading
// ====================================
// Indica que o mapa e as info dos lugares estão em carregamento.
class MapsLoading extends MapsState {}

// ====================================
// Estado MapsLoaded
// ====================================
// Indica que a localização do usuário e os lugares foram carregados com sucesso.
// Contém a localização atual do usuário e uma lista de lugares.
class MapsLoaded extends MapsState {
  final Position userLocation; // Localização do usuário
  final List<Place> places; // Lista de lugares carregados

  MapsLoaded({required this.userLocation, required this.places});

  // Importante para comparar os objetos do estado de forma correta
  @override
  List<Object?> get props => [userLocation, places];
}

// ====================================
// Estado MapsError
// ====================================
// Indica que ocorreu um erro ao carregar o mapa ou os lugares.
class MapsError extends MapsState {
  final String message; // Mensagem de erro

  MapsError(this.message);

  @override
  List<Object?> get props => [message];
}
