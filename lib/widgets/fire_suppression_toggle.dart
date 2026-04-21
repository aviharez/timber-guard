import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timber_guard/theme/app_theme.dart';

/// Toggle switch for the integrated fire suppression system.
/// When enabled, a 15% discount is applied to the estimated premium.
class FireSuppressionToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FireSuppressionToggle({
    super.key,
    required this.value,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? AppTheme.forestGreenSurface : AppTheme.offWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppTheme.forestGreen.withOpacity(0.4) : AppTheme.lightBorder,
          width: 1.5
        )
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value ? AppTheme.forestGreen.withOpacity(0.15) : AppTheme.slateGreyMuted.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: value ? AppTheme.forestGreen : AppTheme.slateGreyLight,
              size: 20
            )
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fire Suppression System',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkText
                  )
                ),
                const SizedBox(height: 2),
                Text(
                  value ? '15% discount applied' : 'Enable for a 15% premium discount',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: value ? AppTheme.successGreen : AppTheme.slateGreyLight,
                    fontWeight: value ? FontWeight.w600 : FontWeight.w400
                  )
                )
              ]
            )
          ),
          Switch(
            value: value,
            onChanged: onChanged
          )
        ]
      ),
    );
  }
}