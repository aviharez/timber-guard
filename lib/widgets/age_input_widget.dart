import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timber_guard/theme/app_theme.dart';
import 'package:timber_guard/utils/premium_calculator.dart';

/// Validated text field for equipment age (in years).
/// Emits [onAgeChanged] with a valid non-negative integer, or null when the
/// input is empty or invalid. The parent uses null to disable the estimator
/// gracefully rather than showing stale numbers.
class AgeInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<int?> onAgeChanged;

  const AgeInputWidget({
    super.key,
    required this.controller,
    required this.onAgeChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 16, color: AppTheme.forestGreen),
            const SizedBox(width: 6),
            Text(
              'Equipment Age (years)',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.slateGrey,
                letterSpacing: 0.4
              )
            )
          ]
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            // Prevent entering more than 3 digits (max 999 years is plenty)
            LengthLimitingTextInputFormatter(3)
          ],
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkText
          ),
          decoration: InputDecoration(
            hintText: 'e.g. 5',
            suffixText: 'yrs',
            suffixStyle: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.slateGreyLight
            )
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Please enter equipment age';
            final age = int.tryParse(val);
            if (age == null || age < 0) return 'Enter a valid oge (0 or more)';
            return null; // Age > 20 is valid input; the UI handles it separately.
          },
          onChanged: (val) {
            final age = int.tryParse(val);
            onAgeChanged(age);
          }
        ),
        // Soft warning. Not a validation error, just informs the user they
        // will be redirected to the agent contact message.
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, tv, _) {
            final age = int.tryParse(tv.text);
            if (age != null && age > PremiumCalculator.maxAgeYears) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: AppTheme.warningAmber),
                    const SizedBox(width: 6),
                    // Flexible prevents overflow on narrow mobile viewports.
                    Flexible(
                      child: Text(
                        'Equipment over ${PremiumCalculator.maxAgeYears} years requires agent review.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.warningAmber,
                          fontWeight: FontWeight.w500
                        )
                      )
                    )
                  ]
                )
              );
            }
            return const SizedBox.shrink();
          }
        )
      ]
    );
  }
}