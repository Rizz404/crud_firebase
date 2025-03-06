import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  final VoidCallback onFilterSelected;
  final Color color;
  final bool isSelected;

  const FilterItem({
    super.key,
    required this.onFilterSelected,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 2,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
