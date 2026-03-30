import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class HeroImageCard extends StatelessWidget {
  final String imageUrl;
  final Widget content;
  final double height;
  final double borderRadius;
  final Gradient? overlay;

  const HeroImageCard({
    super.key,
    required this.imageUrl,
    required this.content,
    this.height = 160,
    this.borderRadius = 20,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              placeholder: (c, u) => Shimmer.fromColors(
                baseColor: const Color(0xFFE0E0E0),
                highlightColor: const Color(0xFFF5F5F5),
                child: Container(color: const Color(0xFFE0E0E0)),
              ),
              errorWidget: (c, u, e) => Container(
                color: const Color(0xFFF0F0F0),
                child: const Icon(Icons.fitness_center,
                    color: Color(0xFFE8191B), size: 32),
              ),
            ),
            if (overlay != null)
              Container(decoration: BoxDecoration(gradient: overlay)),
            Padding(padding: const EdgeInsets.all(16), child: content),
          ],
        ),
      ),
    );
  }
}
