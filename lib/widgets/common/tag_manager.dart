import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/text_styles.dart';

class TagManager extends StatefulWidget {
  final List<String> tags;
  final Function(String) onTagAdd;
  final Function(String) onTagRemove;

  const TagManager({
    Key? key,
    required this.tags,
    required this.onTagAdd,
    required this.onTagRemove,
  }) : super(key: key);

  @override
  State<TagManager> createState() => _TagManagerState();
}

class _TagManagerState extends State<TagManager> {
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        _tagController.text.trim().isNotEmpty) {
      widget.onTagAdd(_tagController.text.trim());
      _tagController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('태그', style: AppTextStyles.bodyLarge),
        const SizedBox(height: 8),
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: _handleKeyPress,
          child: TextField(
            controller: _tagController,
            decoration: InputDecoration(
              hintText: '태그를 입력하고 Enter를 누르세요',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.midGray,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.lightGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.lightGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              widget.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tag,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => widget.onTagRemove(tag),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
