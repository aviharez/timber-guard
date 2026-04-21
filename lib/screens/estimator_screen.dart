import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timber_guard/models/equipment_model.dart';
import 'package:timber_guard/utils/premium_calculator.dart';
import 'package:timber_guard/theme/app_theme.dart';

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
    _ageController.text = '$_defaultAge';
    setState(() {
      _equipmentType = _defaultType;
      _equipmentValue = _defaultValue;
      _equipmentAge = _defaultAge;
      _hasFireSuppression = _defaultFire;

      _resetCounter++;
    });
  }

  // Premium calculation

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
    // TODO: implement build
    throw UnimplementedError();
  }

}

// Header
class _Header extends StatelessWidget {
  final VoidCallback onReset;

  const _Header({required this.onReset});

  @override
  Widget build(BuildContext context) {
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
            ]
          )
        )
      )
    );
  }
}