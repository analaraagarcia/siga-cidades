import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sigacidades/domain/repositories/place_repository.dart';
import 'distances_event.dart';
import 'distances_state.dart';

class DistancesBloc extends Bloc<DistancesEvent, DistancesState> {
  final PlaceRepository placeRepository;

  DistancesBloc(this.placeRepository) : super(DistancesInitial()) {
    on<FetchNearbyPlacesEvent>(_onFetchNearbyPlaces);
  }

  // ====================================
  // Função para verificar se o serviço de localização está ativo
  // ====================================
  Future<bool> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  // ====================================
  // Função para lidar com o evento de buscar os lugares próximos
  // ====================================
  Future<void> _onFetchNearbyPlaces(
    FetchNearbyPlacesEvent event,
    Emitter<DistancesState> emit,
  ) async {
    try {
      emit(DistancesLoading());

      // Verifica se o serviço de localização está habilitado
      if (!await _checkLocationService()) {
        emit(DistancesError(
            "Serviço de localização está desativado. Por favor, ative-o nas configurações."));
        return;
      }

      // Verifica e solicita a permissão de localização
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(DistancesPermissionRequired(
              "Permissão de localização é necessária para buscar lugares próximos."));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(DistancesError(
            "Permissão de localização foi negada permanentemente. Habilite nas configurações."));
        return;
      }

      // Definindo as configurações de localização
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.medium, // Precisão máxima da localização
        distanceFilter:
            100, // Atualizar a localização quando o usuário mover 100 metros
      );

      // Pega a posição atual do usuário usando as novas configurações de localização
      Position userPosition = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings, // Passa as configurações
      );

      // Busca os lugares mais próximos e suas distâncias
      final nearbyPlacesWithDistances =
          await placeRepository.fetchNearbyPlaces(userPosition);

      // Emite o estado com os lugares e suas distâncias
      emit(DistancesLoaded(nearbyPlacesWithDistances));
    } catch (e) {
      emit(DistancesError("Erro ao buscar lugares próximos: $e"));
    }
  }
}
