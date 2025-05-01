import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final double latitude;
  final double longitude;
  final String? address;
  final String? placeName;

  Location({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      address: json['address'] as String?,
      placeName: json['placeName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'placeName': placeName,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      address: map['address'] as String?,
      placeName: map['placeName'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'placeName': placeName,
    };
  }

  /// FireStore의 GeoPoint로 변환
  GeoPoint toGeoPoint() {
    return GeoPoint(latitude, longitude);
  }
}
