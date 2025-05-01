import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/diary.dart';

class MediaUploader extends StatefulWidget {
  final List<MediaItem> media;
  final Function(MediaItem) onMediaAdd;
  final Function(MediaItem) onMediaRemove;

  const MediaUploader({
    Key? key,
    required this.media,
    required this.onMediaAdd,
    required this.onMediaRemove,
  }) : super(key: key);

  @override
  State<MediaUploader> createState() => _MediaUploaderState();
}

class _MediaUploaderState extends State<MediaUploader> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );

      if (image != null) {
        final mediaItem = MediaItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'image',
          url: image.path,
          thumbnail: image.path,
          createdAt: DateTime.now(),
        );
        widget.onMediaAdd(mediaItem);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('사진', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 8),
        if (widget.media.isEmpty)
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('사진 추가'),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.media.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.media.length) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate,
                          color: AppColors.midGray,
                          size: 32,
                        ),
                      ),
                    ),
                  );
                }

                final media = widget.media[index];
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(media.url),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => widget.onMediaRemove(media),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
