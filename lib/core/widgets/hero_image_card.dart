import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class HeroImageCard extends StatelessWidget {
  final String imageUrl;
  final Widget content;
  final double height;
  final double borderRadius;
  final Gradient overlay;
  final BoxFit fit;

  const HeroImageCard({
    super.key,
    required this.imageUrl,
    required this.content,
    this.height = 160,
    this.borderRadius = 20,
    this.overlay = AppColors.imageOverlay,
    this.fit = BoxFit.cover,
  });

  Widget _buildNetworkImage(String url, double? height, BoxFit fit) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: double.infinity,
      fit: fit,
      filterQuality: FilterQuality.high,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: const Color(0xFF1A1A1A),
        highlightColor: const Color(0xFF2A2A2A),
        child: Container(color: const Color(0xFF1A1A1A), height: height),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        color: const Color(0xFF1A1A1A),
        child: Center(
          child: Icon(Icons.fitness_center, color: AppColors.orange, size: 32),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background image
            _buildNetworkImage(imageUrl, height, fit),
            // 2. Gradient overlay
            Container(decoration: BoxDecoration(gradient: overlay)),
            // 3. Content on top
            Padding(padding: const EdgeInsets.all(16), child: content),
          ],
        ),
      ),
    );
  }
}
