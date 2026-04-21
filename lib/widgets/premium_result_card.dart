import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timber_guard/theme/app_theme.dart';
import 'package:timber_guard/utils/premium_calculator.dart';

/// Displays the calculated monthly premium or a "Contact Agent" call-to-action
/// when the equipment age exceeds the instant-quote threshold.
class PremiumResultCard extends StatelessWidget {
  // Null means age is out of range -> show agent CTA.
  final double? monthlyPremium;
  final bool hasFireSuppression;
  final double equipmentValue;
  final int? equipmentAge;

  const PremiumResultCard({
    super.key,
    required this.monthlyPremium,
    required this.hasFireSuppression,
    required this.equipmentValue,
    required this.equipmentAge
  });

  @override
  Widget build(BuildContext context) {
    // Age exceeds threshold. No instant quote available.
    if (equipmentAge != null && equipmentAge! > PremiumCalculator.maxAgeYears) {
      return const _AgentCtaCard();
    }

    return _PremiumDisplay(
      monthlyPremium: monthlyPremium,
      hasFireSuppression: hasFireSuppression,
      equipmentValue: equipmentValue
    );
  }
}

// Premium display

class _PremiumDisplay extends StatelessWidget {
  final double? monthlyPremium;
  final bool hasFireSuppression;
  final double equipmentValue;

  const _PremiumDisplay({
    required this.monthlyPremium,
    required this.hasFireSuppression,
    required this.equipmentValue
  });

  String _formatUSD(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final double savings = hasFireSuppression ? PremiumCalculator.fireSavingsPerMonth(equipmentValue) : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.forestGreenDark, AppTheme.forestGreen]
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.forestGreen.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8)
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 22)
                ),
                const SizedBox(width: 12),
                // Expanded prevents overflow when card is narrow on mobile.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Monthly Premium',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 0.3
                        ),
                        overflow: TextOverflow.ellipsis
                      ),
                      Text(
                        'Shield & Sapling Forestry Insurance',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.55)
                        ),
                        overflow: TextOverflow.ellipsis
                      )
                    ]
                  )
                )
              ]
            )
          ),

          // Main amount
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.15),
                    end: Offset.zero
                  ).animate(anim),
                  child: child
                )
              ),
              child: monthlyPremium == null
                ? const _PlaceholderAmount(key: ValueKey('placeholder'))
                : Text(
                    _formatUSD(monthlyPremium!),
                    key: ValueKey(monthlyPremium!.toStringAsFixed(2)),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -1
                    )
                  )
            )
          ),

          // Divider
          Divider(
            color: Colors.white.withOpacity(0.15),
            height: 1,
            indent: 24,
            endIndent: 24
          ),

          // Breakdown chips
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              children: [
                const _BreakdownRow(
                  label: 'Base Rate',
                  value: '2.0% / year',
                  icon: Icons.percent_rounded
                ),
                const SizedBox(height: 10),
                const _BreakdownRow(
                  label: 'Billing period',
                  value: 'Monthly',
                  icon: Icons.calendar_month_rounded
                ),
                if (hasFireSuppression) ...[
                  const SizedBox(height: 10),
                  _BreakdownRow(
                    label: 'Fire suppression discount',
                    value: '-${_formatUSD(savings)}/mo',
                    icon: Icons.local_fire_department_rounded,
                    valueColor: const Color(0xFF86EFAC)
                  )
                ]
              ]
            )
          ),

          // Disclaimer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16)
              )
            ),
            child: Text(
              'Estimate only. Final premium subject to full underwriting review.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.white.withOpacity(0.55)
              )
            )
          )
        ]
      )
    );
  }
}

class _PlaceholderAmount extends StatelessWidget {
  const _PlaceholderAmount({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '-',
      style: GoogleFonts.playfairDisplay(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: Colors.white.withOpacity(0.4)
      )
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _BreakdownRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white.withOpacity(0.6)),
        const SizedBox(width: 8),
        // Expanded prevents the label from overflowing on narrow viewports.
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7)
            ),
            overflow: TextOverflow.ellipsis,
          )
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.white
          )
        )
      ]
    );
  }
}

// Agent CTA

class _AgentCtaCard extends StatelessWidget {
  const _AgentCtaCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.earthBrown.withOpacity(0.9),
            AppTheme.earthBrown
          ]
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.earthBrown.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8)
          )
        ]
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle
            ),
            child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 36)
          ),
          const SizedBox(height: 20),
          Text(
            'Contact Agent for\nCustom Quote',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3
            )
          ),
          const SizedBox(height: 12),
          Text(
            'Equipment older than ${PremiumCalculator.maxAgeYears} years requires a '
                'personalized underwriting review. Out specialists will assess '
                'condition, service history, and risk profile to provide a tailored rate.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
              height: 1.6
            )
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            icon: const Icon(Icons.phone_rounded, size: 18),
            label: Text(
              'Request a Custom Quote',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, fontSize: 14
              )
            ),
            onPressed: () {
              // placeholder
            }
          )
        ]
      )
    );
  }
}