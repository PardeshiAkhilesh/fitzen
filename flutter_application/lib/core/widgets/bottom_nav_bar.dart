import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 16)],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.red,
        unselectedItemColor: const Color(0xFF9A9A9A),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTextStyles.labelRed.copyWith(fontSize: 12),
        unselectedLabelStyle: AppTextStyles.caption.copyWith(fontSize: 12),
        items: [
          _buildItem(Icons.home_rounded, "Home", 0),
          _buildItem(Icons.bar_chart_rounded, "Progress", 1),
          _buildItem(Icons.track_changes_rounded, "Goals", 2),
          _buildItem(Icons.person_rounded, "Profile", 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(icon, size: 28),
          if (isSelected)
            Positioned(
              bottom: -15, // Below the label usually, but here adjusting below icon
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
