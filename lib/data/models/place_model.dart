import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sigacidades/domain/entities/place.dart';

// O PlaceModel extende a entidade Place e faz a conversão de JSON para o PlaceModel e do PlaceModel para JSON.
class PlaceModel extends Place {
  PlaceModel({
    required String name,
    required String city,
    required String category,
    required String description,
    required String adress,
    required String imageUrl,
    required String imageDescription,
    required String audioDescriptionUrl,
    required String audioPlaceInfoUrl,
    required GeoPoint coordinates,
  }) : super(
          name: name,
          city: city,
          category: category,
          description: description,
          adress: adress,
          imageUrl: imageUrl,
          imageDescription: imageDescription,
          audioDescriptionUrl: audioDescriptionUrl,
          audioPlaceInfoUrl: audioPlaceInfoUrl,
          coordinates: coordinates,
        );

  // Converte um objeto JSON para um PlaceModel.
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['name'],
      city: json['city'],
      category: json['category'],
      description: json['description'],
      adress: json['adress'],
      imageUrl: json['imageUrl'],
      imageDescription: json['imageDescription'],
      audioDescriptionUrl: json['audioDescriptionUrl'],
      audioPlaceInfoUrl: json['audioPlaceInfoUrl'],
      coordinates: json['coordinates'],
    );
  }

  // Converte o PlaceModel para um objeto JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'category': category,
      'description': description,
      'adress': adress,
      'imageUrl': imageUrl,
      'imageDescription': imageDescription,
      'audioDescriptionUrl': audioDescriptionUrl,
      'audioPlaceInfoUrl': audioPlaceInfoUrl,
      'coordinates': coordinates,
    };
  }
}
