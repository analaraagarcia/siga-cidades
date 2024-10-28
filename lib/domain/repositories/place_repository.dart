import 'package:sigacidades/domain/entities/place.dart';
import 'package:geolocator/geolocator.dart'; // Para o cálculo de distância

// Interface do Repositório.
// A camada de domínio define o contrato e a entidade
// O contrato é gerado com base no paradigma orientado a objetos, se trata da interface que a camada de dados deve implementar.
abstract class PlaceRepository {
  // Busca lugares com base na categoria.
  Future<List<Place>> fetchPlacesByCategory(int categoryIndex);

  // Busca lugares com base na cidade.
  Future<List<Place>> fetchPlacesByCity(String city);

  // Busca lugares próximos com base na posição do usuário.
  Future<List<Map<String, dynamic>>> fetchNearbyPlaces(
      Position
          userPosition); // Atualizado para retornar um mapa contendo Place e distância

  // Busca todos os lugares com base na posição do usuário para o mapa.
  Future<List<Place>> fetchPlacesMap(Position userPosition);
}
