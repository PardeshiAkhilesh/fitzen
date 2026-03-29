import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AiInputBar extends StatefulWidget {
  const AiInputBar({super.key});

  @override
  State<AiInputBar> createState() => _AiInputBarState();
}

class _AiInputBarState extends State<AiInputBar> with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
       vsync: this, 
       duration: const Duration(milliseconds: 600)
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: _isRecording ? AppColors.orange.withOpacity(0.08) : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: _isRecording ? AppColors.orange : AppColors.divider, width: _isRecording ? 2 : 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() => _isRecording = !_isRecording);
            },
            child: _isRecording 
              ? ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.1).animate(_animController),
                  child: const Icon(Icons.mic_rounded, color: AppColors.orange, size: 24),
                )
              : const Icon(Icons.mic_rounded, color: AppColors.orange, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: AppTextStyles.body,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: _isRecording ? "Listening... tap to stop 🎙️" : "Log food or workout...",
                hintStyle: AppTextStyles.body.copyWith(
                  color: _isRecording ? AppColors.orange : AppColors.textMuted
                ),
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              color: AppColors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
