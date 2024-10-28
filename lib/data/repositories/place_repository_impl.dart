import 'package:sigacidades/domain/entities/place.dart';
import 'package:sigacidades/domain/repositories/place_repository.dart';
import 'package:sigacidades/data/models/place_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

/// Faz a implementação do place_repository.dart contendo os lugares, usando o Firebase Firestore para obter os dados.
class PlaceRepositoryImpl implements PlaceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ====================================
  // Seção: Busca de lugares por categoria
  // ====================================
  // Faz o uso do index da categoria para consultar o Firestore e obter os lugares respectivos.
  @override
  Future<List<Place>> fetchPlacesByCategory(int categoryIndex) async {
    final categories = [
      'Bosques e Parques',
      'Comércio',
      'Cultura, Lazer e Esporte',
      'Edificações Públicas',
      'Educação e Terceiro Setor',
      'Logradouros e Praças',
      'Religião',
      'Saúde'
    ];

    // Verifica se o index da categoria está dentro do limite da lista
    if (categoryIndex < 0 || categoryIndex >= categories.length) {
      return []; // Retorna uma lista vazia se o index for inválido.
    }

    // Usa o index para acessar o nome da categoria.
    final category = categories[categoryIndex];

    // Faz a consulta no Firestore para obter lugares que pertencem a uma categoria específica.
    QuerySnapshot querySnapshot = await _firestore
        .collection('lugares')
        .where('category', isEqualTo: category)
        .get();

    // Converte os documentos recebidos do Firestore em uma lista de objetos Place chamando o método da place_model.dart.
    return querySnapshot.docs
        .map((doc) => PlaceModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // ====================================
  // Seção: Busca de lugares por cidade
  // ====================================
  // Consulta Firestore para obter lugares da cidade especificada.
  @override
  Future<List<Place>> fetchPlacesByCity(String city) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('lugares')
        .where('city', isEqualTo: city)
        .get();

    // Converte os documentos recebidos do Firestore em uma lista de objetos Place chamando o método da place_model.dart.
    return querySnapshot.docs
        .map((doc) => PlaceModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // ====================================
  // Seção: Busca de lugares próximos ao usuário
  // ====================================
  // Realiza uma consulta geral no Firestore e calcula a distância para cada lugar em relação a localização do usuário.
  @override
  Future<List<Map<String, dynamic>>> fetchNearbyPlaces(
      Position userPosition) async {
    // Traz todos os lugares do Firestore
    QuerySnapshot querySnapshot = await _firestore.collection('lugares').get();

    List<Map<String, dynamic>> placesWithDistance = [];

    // Calcula a distância para cada lugar e armazena o lugar e a distância usando a Geolocator.distanceBetween
    for (var doc in querySnapshot.docs) {
      Place place = PlaceModel.fromJson(doc.data() as Map<String, dynamic>);

      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        place.coordinates.latitude,
        place.coordinates.longitude,
      );

      // Adiciona o lugar e o cálculo da distância do lugar em relação ao usuário a lista placesWithDistance
      placesWithDistance.add({
        'place': place,
        'distance': distanceInMeters,
      });
    }

    // Faz a ordenação pela distância mais próxima e retorna os 9 lugares mais próximos do usuário
    placesWithDistance.sort((a, b) => a['distance'].compareTo(b['distance']));
    return placesWithDistance.take(9).toList();
  }

  // ====================================
  // Seção: Busca de lugares para o mapa
  // ====================================
  // Retorna uma lista de lugares que fica ordenada pela proximidade em relação ao usuário (usado no mapa).
  @override
  Future<List<Place>> fetchPlacesMap(Position userPosition) async {
    QuerySnapshot querySnapshot = await _firestore.collection('lugares').get();

    List<Place> allNearbyPlaces = querySnapshot.docs
        .map((doc) => PlaceModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Faz a ordenação dos lugares pela proximidade em relação ao usuário
    allNearbyPlaces.sort((a, b) {
      // Faz o cálculo da distância entre a posição do usuário e a coordenada do primeiro lugar (a)
      double distanceA = Geolocator.distanceBetween(
          userPosition.latitude, // Latitude do usuário
          userPosition.longitude, // Longitude do usuário
          a.coordinates.latitude, // Latitude do lugar (a)
          a.coordinates.longitude // Longitude do lugar (a)
          );

      // Faz o cálculo da distância entre a posição do usuário e a coordenada do segundo lugar (b)
      double distanceB = Geolocator.distanceBetween(
          userPosition.latitude, // Latitude do usuário
          userPosition.longitude, // Longitude do usuário
          b.coordinates.latitude, // Latitude do lugar (b)
          b.coordinates.longitude // Longitude do lugar (b)
          );

      // Compara as duas distâncias. O lugar com a menor distância será o primeiro da lista
      // Número negativo se distanceA < distanceB, zero se iguais e positivo se distanceA > distanceB.
      return distanceA.compareTo(distanceB);
    });

    // Retorna a lista de lugares ordenada por proximidade (do mais próximo ao mais distante).
    return allNearbyPlaces;
  }
}
