import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timber_guard/models/equipment_model.dart';
import 'package:timber_guard/utils/premium_calculator.dart';
import 'package:timber_guard/theme/app_theme.dart';
import 'package:timber_guard/widgets/age_input_widget.dart';
import 'package:timber_guard/widgets/equipment_type_dropdown.dart';
import 'package:timber_guard/widgets/premium_result_card.dart';
import 'package:timber_guard/widgets/value_slider_widget.dart';

import '../widgets/fire_suppression_toggle.dart';

/// Root screen of the TimberGuard Premium Estimator.
///
/// Owns all estimator state and recalculates the premium on every change
/// without requiring a submit action
class EstimatorScreen extends StatefulWidget {
  const EstimatorScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EstimatorScreenState();
}

class _EstimatorScreenState extends State<EstimatorScreen> {
  // Default values
  static const EquipmentType _defaultType = EquipmentType.fellerBuncher;
  static const double _defaultValue = 200000;
  static const int _defaultAge = 5;
  static const bool _defaultFire = false;

  // State
  EquipmentType _equipmentType = _defaultType;
  double _equipmentValue = _defaultValue;
  int? _equipmentAge = _defaultAge;
  bool _hasFireSuppression = _defaultFire;

  // Incrementing this key destroys and recreates _InputPanel, which resets
  // DropdownButtonFormField's internal FormFieldState to the current prop value.
  int _resetCounter = 0;

  final TextEditingController _ageController = TextEditingController(text: '$_defaultAge');

  // Lifecycle

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  // Actions

  void _reset() {
    // Set the controller text before setState so the new _InputPanel that
    // Flutter creates (due to the key change) initializes with '5' already set.
    _ageController.text = '$_defaultAge';
    setState(() {
      _equipmentType = _defaultType;
      _equipmentValue = _defaultValue;
      _equipmentAge = _defaultAge;
      _hasFireSuppression = _defaultFire;
      // Changing the key forces _InputPanel to be fully recreated, so
      // DropdownButtonFormField starts fresh with the new default type.
      _resetCounter++;
    });
  }

  // Premium calculation

  /// Returns the monthly premium, or null when the age is out of range or
  /// the age field is empty/invalid (preventing stale numbers from showing).
  double? get _monthlyPremium {
    if (_equipmentAge == null) return null;
    return PremiumCalculator.calculateMonthlyPremium(
      equipmentValue: _equipmentValue,
      equipmentAge: _equipmentAge!,
      hasFireSuppression: _hasFireSuppression
    );
  }

  // Build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: Column(
        children: [
          _Header(onReset: _reset),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 48 : 20,
                    vertical: 32
                  ),
                  child: isDesktop
                    ? _DesktopLayout(
                        resetCounter: _resetCounter,
                        equipmentType: _equipmentType,
                        equipmentValue: _equipmentValue,
                        hasFireSuppression: _hasFireSuppression,
                        equipmentAge: _equipmentAge,
                        ageController: _ageController,
                        monthlyPremium: _monthlyPremium,
                        onTypeChanged: (v) => setState(() => _equipmentType = v),
                        onValueChanged: (v) => setState(() => _equipmentValue = v),
                        onFireChanged: (v) => setState(() => _hasFireSuppression = v),
                        onAgeChanged: (v) => setState(() => _equipmentAge = v)
                      )
                    : _MobileLayout(
                        resetCounter: _resetCounter,
                        equipmentType: _equipmentType,
                        equipmentValue: _equipmentValue,
                        hasFireSuppression: _hasFireSuppression,
                        equipmentAge: _equipmentAge,
                        ageController: _ageController,
                        monthlyPremium: _monthlyPremium,
                        onTypeChanged: (v) => setState(() => _equipmentType = v),
                        onValueChanged: (v) => setState(() => _equipmentValue = v),
                        onFireChanged: (v) => setState(() => _hasFireSuppression = v),
                        onAgeChanged: (v) => setState(() => _equipmentAge = v)
                      )
                );
              }
            )
          ),
          const _Footer()
        ]
      )
    );
  }
}

// Header
class _Header extends StatelessWidget {
  final VoidCallback onReset;

  const _Header({required this.onReset});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery instead of a nested LayoutBuilder to avoid two concurrent
    // RenderLayoutBuilder instances in the same frame, which can cause
    // _RenderDeferredLayoutBox mutation errors.
    final isDesktop = MediaQuery.sizeOf(context).width > 800;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.forestGreenDark, AppTheme.forestGreen]
        )
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Brand mark
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1)
                ),
                child: const Icon(Icons.forest_rounded, color: Colors.white, size: 28)
              ),
              const SizedBox(width: 16),

              // Title block
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TimberGuard',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: isDesktop ? 32 : 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5
                      )
                    ),
                    Text(
                      'Shield & Sapling - Forestry Equipment Insurance',
                      style: GoogleFonts.inter(
                        fontSize: isDesktop ? 14 : 12,
                        color: Colors.white.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w400
                      )
                    )
                  ]
                )
              ),

              // Reset button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54, width: 1.2),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 20 : 14,
                    vertical: 12
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                icon: const Icon(Icons.restart_alt_rounded, size: 18),
                label: Text(
                  isDesktop ? 'Reset' : '',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)
                ),
                onPressed: onReset
              )
            ]
          )
        )
      )
    );
  }
}

// Input panel (shared by both layouts)

class _InputPanel extends StatelessWidget {
  final EquipmentType equipmentType;
  final double equipmentValue;
  final bool hasFireSuppression;
  final TextEditingController ageController;
  final ValueChanged<EquipmentType> onTypeChanged;
  final ValueChanged<double> onValueChanged;
  final ValueChanged<bool> onFireChanged;
  final ValueChanged<int?> onAgeChanged;

  const _InputPanel({
    super.key,
    required this.equipmentType,
    required this.equipmentValue,
    required this.hasFireSuppression,
    required this.ageController,
    required this.onTypeChanged,
    required this.onValueChanged,
    required this.onFireChanged,
    required this.onAgeChanged
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PanelHeading(
                icon: Icons.tune_rounded,
                title: 'Equipment Details',
                subtitle: 'Adjust the fields below. Your estimate updates instantly.'
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              EquipmentTypeDropdown(
                value: equipmentType,
                onChanged: onTypeChanged
              ),
              const SizedBox(height: 28),

              ValueSliderWidget(
                value: equipmentValue,
                onChanged: onValueChanged
              ),
              const SizedBox(height: 28),

              AgeInputWidget(
                controller: ageController,
                onAgeChanged: onAgeChanged
              ),
              const SizedBox(height: 24),

              FireSuppressionToggle(
                value: hasFireSuppression,
                onChanged: onFireChanged
              )
            ]
          )
        )
      )
    );
  }
}

// Result panel (shared)

class _ResultPanel extends StatelessWidget {
  final double? monthlyPremium;
  final bool hasFireSuppression;
  final double equipmentValue;
  final int? equipmentAge;

  const _ResultPanel({
    required this.monthlyPremium,
    required this.hasFireSuppression,
    required this.equipmentValue,
    required this.equipmentAge
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PanelHeading(
          icon: Icons.calculate_rounded,
          title: 'Your Estimate',
          subtitle: 'Live calculation. No submission required.'
        ),
        const SizedBox(height: 16),
        PremiumResultCard(
          monthlyPremium: monthlyPremium,
          hasFireSuppression: hasFireSuppression,
          equipmentValue: equipmentValue,
          equipmentAge: equipmentAge
        ),
        const SizedBox(height: 16),
        const _InfoChips()
      ]
    );
  }
}

// Desktop two-column layout

class _DesktopLayout extends StatelessWidget {
  final int resetCounter;
  final EquipmentType equipmentType;
  final double equipmentValue;
  final bool hasFireSuppression;
  final int? equipmentAge;
  final TextEditingController ageController;
  final double? monthlyPremium;
  final ValueChanged<EquipmentType> onTypeChanged;
  final ValueChanged<double> onValueChanged;
  final ValueChanged<bool> onFireChanged;
  final ValueChanged<int?> onAgeChanged;

  const _DesktopLayout({
    required this.resetCounter,
    required this.equipmentType,
    required this.equipmentValue,
    required this.hasFireSuppression,
    required this.equipmentAge,
    required this.ageController,
    required this.monthlyPremium,
    required this.onTypeChanged,
    required this.onValueChanged,
    required this.onFireChanged,
    required this.onAgeChanged
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Inputs. ValueKey forces recreation on reset so that
        // DropdownButtonFormField's internal state is flushed
        Expanded(
          flex: 5,
          child: _InputPanel(
            key: ValueKey(resetCounter),
            equipmentType: equipmentType,
            equipmentValue: equipmentValue,
            hasFireSuppression: hasFireSuppression,
            ageController: ageController,
            onTypeChanged: onTypeChanged,
            onValueChanged: onValueChanged,
            onFireChanged: onFireChanged,
            onAgeChanged: onAgeChanged
          )
        ),
        const SizedBox(width: 28),
        // Right: result
        Expanded(
          flex: 4,
          child: _ResultPanel(
            monthlyPremium: monthlyPremium,
            hasFireSuppression: hasFireSuppression,
            equipmentValue: equipmentValue,
            equipmentAge: equipmentAge
          )
        )
      ]
    );
  }
}

// Mobile single-column layout

class _MobileLayout extends StatelessWidget {
  final int resetCounter;
  final EquipmentType equipmentType;
  final double equipmentValue;
  final bool hasFireSuppression;
  final int? equipmentAge;
  final TextEditingController ageController;
  final double? monthlyPremium;
  final ValueChanged<EquipmentType> onTypeChanged;
  final ValueChanged<double> onValueChanged;
  final ValueChanged<bool> onFireChanged;
  final ValueChanged<int?> onAgeChanged;

  const _MobileLayout({
    required this.resetCounter,
    required this.equipmentType,
    required this.equipmentValue,
    required this.hasFireSuppression,
    required this.equipmentAge,
    required this.ageController,
    required this.monthlyPremium,
    required this.onTypeChanged,
    required this.onValueChanged,
    required this.onFireChanged,
    required this.onAgeChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InputPanel(
          key: ValueKey(resetCounter),
          equipmentType: equipmentType,
          equipmentValue: equipmentValue,
          hasFireSuppression: hasFireSuppression,
          ageController: ageController,
          onTypeChanged: onTypeChanged,
          onValueChanged: onValueChanged,
          onFireChanged: onFireChanged,
          onAgeChanged: onAgeChanged
        ),
        const SizedBox(height: 24),
        _ResultPanel(
          monthlyPremium: monthlyPremium,
          hasFireSuppression: hasFireSuppression,
          equipmentValue: equipmentValue,
          equipmentAge: equipmentAge
        )
      ]
    );
  }
}

// Shared minor widgets

class _PanelHeading extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PanelHeading({
    required this.icon,
    required this.title,
    required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.forestGreenSurface,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Icon(icon, color: AppTheme.forestGreen, size: 20)
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkText
                )
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.slateGreyLight
                )
              )
            ]
          )
        )
      ]
    );
  }
}

// Info Chips

class _InfoChips extends StatelessWidget {
  const _InfoChips();

  @override
  Widget build(BuildContext context) {
    const chips = [
      (Icons.verified_rounded, 'Instant Estimate'),
      (Icons.lock_rounded, 'No Commitment'),
      (Icons.headset_mic_rounded, 'Agent Follow-Up Available')
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips.map((c) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.cardWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.lightBorder)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(c.$1, size: 12, color: AppTheme.forestGreen),
              const SizedBox(width: 6),
              Text(
                c.$2,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.slateGrey
                )
              )
            ]
          )
        );
      }).toList()
    );
  }
}

// Footer

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.forestGreenDark,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.forest_rounded, color: Colors.white54, size: 14),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '2026 Shield & Sapling Insurance - TimberGuard v1.0',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
              overflow: TextOverflow.ellipsis
            )
          )
        ]
      )
    );
  }
}