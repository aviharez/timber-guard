import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timber_guard/theme/app_theme.dart';

/// Slider for declaring the equipment value between $50k and $1M.
class ValueSliderWidget extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  static const double minValue = 50000;
  static const double maxValue = 1000000;

  const ValueSliderWidget({
    super.key,
    required this.value,
    required this.onChanged
  });

  String _formatCurrency(double amount) {
    if (amount >= 1000000) return '\$1M';
    if (amount >= 1000) {
      final k = (amount / 1000).round();
      return '\$$k k';
    }
    return '\$${amount.round()}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.attach_money_rounded, size: 16, color: AppTheme.forestGreen),
                const SizedBox(width: 6),
                Text(
                  'Equipment Value',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.slateGrey,
                    letterSpacing: 0.4
                  )
                )
              ]
            ),
            // Live value badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.forestGreenSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.forestGreen.withOpacity(0.3), width: 1
                )
              ),
              child: Text(
                _formatCurrency(value),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.forestGreen
                )
              )
            )
          ]
        ),
        const SizedBox(height: 4),
        Slider(
          value: value,
          min: minValue,
          max: maxValue,
          divisions: 190,
          label: _formatCurrency(value),
          onChanged: onChanged
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$50k', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.slateGreyLight)),
              Text('\$1M', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.slateGreyLight))
            ]
          )
        )
      ]
    );
  }
}