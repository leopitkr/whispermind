import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/location.dart';

class LocationPicker extends StatefulWidget {
  final Location? location;
  final Function(Location) onLocationSelect;

  const LocationPicker({
    Key? key,
    this.location,
    required this.onLocationSelect,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  bool _isLoading = false;
  String? _error;
  String? _currentAddress;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = Location(
        latitude: position.latitude,
        longitude: position.longitude,
        address: '현재 위치', // 실제로는 Geocoding API를 사용하여 주소를 가져와야 합니다
      );

      widget.onLocationSelect(location);
      _currentAddress = location.address;
    } catch (e) {
      setState(() {
        _error = '위치를 가져오는 중 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('위치', style: AppTextStyles.headingSmall),
        const SizedBox(height: 8),
        if (widget.location != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  widget.location!.address ?? '',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          )
        else
          ElevatedButton(
            onPressed: _isLoading ? null : _getCurrentLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text('현재 위치 추가'),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: AppTextStyles.error),
          ),
        if (_currentAddress != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '현재 위치: $_currentAddress',
              style: AppTextStyles.bodyMedium,
            ),
          ),
      ],
    );
  }
}
