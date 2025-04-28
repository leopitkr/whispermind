import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/location.dart';

class LocationService {
  static Future<Location> getCurrentLocation() async {
    // 위치 권한 확인
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.');
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 주소 정보 가져오기
    String? address;
    String? placeName;
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1',
        ),
        headers: {'User-Agent': 'WhisperMind/1.0'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        address = data['display_name'];
        placeName =
            data['address']['building'] ??
            data['address']['road'] ??
            data['address']['neighbourhood'] ??
            data['address']['suburb'];
      }
    } catch (e) {
      print('주소 정보를 가져오는 중 오류 발생: $e');
    }

    return Location(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      placeName: placeName,
    );
  }
}
