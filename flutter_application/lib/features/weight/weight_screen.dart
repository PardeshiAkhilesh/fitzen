import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/api_constants.dart';
import '../../core/constants/image_constants.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/hero_image_card.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  List<Map<String, dynamic>> _history = [];
  double? _currentWeight;
  double? _targetWeight;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadWeightData();
  }

  Future<void> _loadWeightData() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      await Future.wait([
        _loadHistory(),
        _loadSummary(),
      ]);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadHistory() async {
    try {
      final res = await ApiService.get(ApiConstants.weightHistory);
      if (res is Map) {
        final history = List<Map<String, dynamic>>.from((res['history'] as List?) ?? []);
        if (mounted) {
          setState(() => _history = history);
        }
      }
    } catch (e) {
      debugPrint('Weight history load error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load weight history: $e')),
        );
      }
    }
  }

  Future<void> _loadSummary() async {
    try {
      final res = await ApiService.get(ApiConstants.weightSummary);
      if (res is Map) {
        if (mounted) {
          setState(() {
            _currentWeight = (res['current_weight'] as num?)?.toDouble();
            _targetWeight = (res['target_weight'] as num?)?.toDouble();
          });
        }
      }
    } catch (e) {
      debugPrint('Weight summary load error: $e');
    }
  }

  Future<void> _logWeight(double kg) async {
    if (_isSubmitting) {
      return;
    }

    if (kg <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight in kg.')),
      );
      return;
    }

    try {
      if (mounted) {
        setState(() => _isSubmitting = true);
      }

      await ApiService.post(ApiConstants.weightLog, {
        'weight_kg': double.parse(kg.toStringAsFixed(1)),
        'logged_at': DateTime.now().toUtc().toIso8601String(),
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight logged successfully.')),
      );
      await _loadWeightData();
    } on DioException catch (e) {
      debugPrint('Weight log Dio error: ${e.response?.data ?? e.message}');
      if (!mounted) {
        return;
      }

      final responseData = e.response?.data;
      final detail = responseData is Map<String, dynamic>
          ? (responseData['detail']?.toString() ?? 'Unable to log weight.')
          : (e.message ?? 'Unable to log weight.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(detail)),
      );
    } catch (e) {
      debugPrint('Weight log error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log weight: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showLogSheet() {
    double value = _currentWeight ?? 70.0;
    final controller = TextEditingController(text: value.toStringAsFixed(1));

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, sbSetState) {
          void updateVal(double newVal) {
            value = newVal.clamp(0.1, 500.0);
            controller.text = value.toStringAsFixed(1);
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
            sbSetState(() {});
          }

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 6, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(20))),
                  const SizedBox(height: 12),
                  Text('Log Weight', style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Text(
                    'Enter today\'s weight in kilograms.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => updateVal(value - 0.1),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      SizedBox(
                        width: 140,
                        child: Center(
                          child: TextField(
                            controller: controller,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h1,
                            decoration: const InputDecoration(border: InputBorder.none, suffixText: 'kg'),
                            onChanged: (s) {
                              final parsed = double.tryParse(s);
                              if (parsed != null) {
                                sbSetState(() => value = parsed);
                              }
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => updateVal(value + 0.1),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, minimumSize: const Size.fromHeight(48)),
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            Navigator.of(ctx).pop();
                            final toSend = double.tryParse(controller.text) ?? value;
                            _logWeight(toSend);
                          },
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text('Save Entry', style: AppTextStyles.labelWhite),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedHistory = [..._history]
      ..sort((a, b) {
        final aDate = DateTime.tryParse(a['logged_at']?.toString() ?? '');
        final bDate = DateTime.tryParse(b['logged_at']?.toString() ?? '');

        if (aDate == null && bDate == null) {
          return 0;
        }
        if (aDate == null) {
          return -1;
        }
        if (bDate == null) {
          return 1;
        }

        return aDate.compareTo(bDate);
      });

    final spots = <FlSpot>[];
    final bottomTitles = <String>[];
    for (var i = 0; i < sortedHistory.length; i++) {
      final item = sortedHistory[i];
      final weight = (item['weight_kg'] as num?)?.toDouble() ?? 0.0;
      final loggedAt = DateTime.tryParse(item['logged_at']?.toString() ?? '');
      spots.add(FlSpot(i.toDouble(), weight));
      bottomTitles.add(
        loggedAt == null ? '' : DateFormat('d MMM').format(loggedAt.toLocal()),
      );
    }

    final weights = spots.map((spot) => spot.y).toList();
    final minWeight = weights.isEmpty ? 0.0 : weights.reduce(math.min);
    final maxWeight = weights.isEmpty ? 100.0 : weights.reduce(math.max);
    final minY = weights.isEmpty ? 0.0 : math.max(0, minWeight - 2).toDouble();
    final maxY = weights.isEmpty ? 100.0 : math.max(minY + 4, maxWeight + 2).toDouble();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Weight Journey'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadWeightData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          HeroImageCard(
            imageUrl: AppImages.deadliftWorkout,
            height: 220,
            overlay: AppColors.imageOverlayDark,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weight Journey', style: AppTextStyles.h1White),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _whiteStatChip(
                      'Current',
                      _currentWeight != null
                          ? '${_currentWeight!.toStringAsFixed(1)} kg'
                          : '--',
                      AppColors.black,
                    ),
                    _whiteStatChip(
                      'Target',
                      _targetWeight != null
                          ? '${_targetWeight!.toStringAsFixed(1)} kg'
                          : '--',
                      AppColors.black,
                    ),
                    _whiteStatChip("Lost", _currentWeight != null && _targetWeight != null ? "↓ ${( _currentWeight! - _targetWeight!).toStringAsFixed(1)} kg" : "--", AppColors.success),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Progress', style: AppTextStyles.h2),
          const SizedBox(height: 16),
          Container(
            height: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.cardShadow,
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : spots.isEmpty
                    ? Center(
                        child: Text(
                          'No weight history yet.\nTap "Log Weight" to add your first entry.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(fontSize: 13),
                        ),
                      )
                    : LineChart(
                    LineChartData(
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= bottomTitles.length) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  bottomTitles[index],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (spots.length - 1).toDouble(),
                      minY: minY,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: AppColors.red,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.red.withValues(alpha: 0.08),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _showLogSheet,
        backgroundColor: AppColors.red,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('Log Weight', style: AppTextStyles.labelWhite),
      ),
    );
  }

  Widget _whiteStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xE6FFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
