import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sigacidades/domain/entities/place.dart';
import 'package:sigacidades/domain/repositories/place_repository.dart';
import 'maps_event.dart';
import 'maps_state.dart';

// ====================================
// Classe MapsBloc
// ====================================
// Gerencia o estado do mapa (localização do usuário e lugares) com o uso do Bloc.
// O MapsBloc recebe eventos (MapsEvent) e envia os estados (MapsState).
class MapsBloc extends Bloc<MapsEvent, MapsState> {
  final PlaceRepository placeRepository; // Repositório para buscar os lugares

  MapsBloc(this.placeRepository) : super(MapsLoading()) {
    // Vincula o evento LoadUserLocationAndPlaces ao método que lida com ele
    on<LoadUserLocationAndPlaces>(_onLoadUserLocationAndPlaces);
  }

  // ====================================
  // Função para verificar se o serviço de localização está ativo
  // ====================================
  Future<bool> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  // ====================================
  // Função para lidar com permissões de localização
  // ====================================
  Future<bool> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // ====================================
  // Método _onLoadUserLocationAndPlaces
  // ====================================
  // Responsável por lidar com o evento de carregar a localização do usuário
  // e os lugares próximos. Usa o Geolocator para obter a localização do usuário
  // e emite diferentes estados dependendo do sucesso ou falha.
  Future<void> _onLoadUserLocationAndPlaces(
      LoadUserLocationAndPlaces event, Emitter<MapsState> emit) async {
    emit(MapsLoading()); // Emite estado de loading enquanto processa
    try {
      // Verifica se o serviço de localização está ativo
      if (!await _checkLocationService()) {
        emit(MapsError(
            "Serviço de localização está desativado. Por favor, ative-o nas configurações."));
        return;
      }

      // Verifica e solicita permissões de localização
      if (!await _checkAndRequestLocationPermission()) {
        emit(MapsError(
            "Permissão de localização negada. Por favor, habilite a localização nas configurações do seu dispositivo."));
        return;
      }

      // Define as configurações de localização
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high, // Precisão máxima da localização
        distanceFilter:
            100, // Faz a atualização da localização quando o usuário andar 100 metros
      );

      // Pega a localização atual do usuário com as configurações de localização
      Position userPosition = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings, // Passa as configurações
      );

      // Busca os lugares próximos do usuário usando o repositório
      List<Place> places = await placeRepository.fetchPlacesMap(userPosition);

      // Emite o estado MapsLoaded com a localização do usuário e os lugares
      emit(MapsLoaded(userLocation: userPosition, places: places));
    } catch (e) {
      // Emite um estado de erro no caso de erro
      emit(MapsError('Erro ao carregar o mapa e os lugares.'));
    }
  }
}
