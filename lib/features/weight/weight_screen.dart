import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/image_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';

class WeightScreen extends StatelessWidget {
  const WeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {}, // Log logic mocked
        backgroundColor: AppColors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("+ Log Weight", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroImageCard(
              imageUrl: AppImages.trainerHero,
              height: 220,
              overlay: AppColors.imageOverlay,
              borderRadius: 0,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text("Weight Journey", style: AppTextStyles.h1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statChip("Current", "78.5 kg"),
                      const SizedBox(width: 12),
                      _statChip("Target", "72 kg"),
                      const SizedBox(width: 12),
                      _statChip("Lost", "-0.5 kg ↓", color: AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) => const FlLine(color: Color(0xFF1E1E1E), strokeWidth: 1),
                      ),
                      titlesData: const FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Map dates if real
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0, maxX: 5, minY: 77, maxY: 80,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 80),
                            FlSpot(1, 79.5),
                            FlSpot(2, 79.2),
                            FlSpot(3, 78.8),
                            FlSpot(4, 78.5),
                          ],
                          isCurved: true,
                          color: AppColors.orange,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String val, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        Text(val, style: AppTextStyles.body.copyWith(color: color ?? Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
