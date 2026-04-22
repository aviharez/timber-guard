import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timber_guard/models/equipment_model.dart';
import 'package:timber_guard/theme/app_theme.dart';

/// Dropdown that lets the user select a forestry equipment category.
class EquipmentTypeDropdown extends StatelessWidget {
  final EquipmentType value;
  final ValueChanged<EquipmentType> onChanged;

  const EquipmentTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(
          icon: Icons.agriculture_rounded,
          label: 'Equipment Type'
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<EquipmentType>(
          initialValue: value,
          decoration: const InputDecoration(
            hintText: 'Select equipment type'
          ),
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkText
          ),
          dropdownColor: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppTheme.forestGreen
          ),
          items: EquipmentType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.displayName)
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          }
        )
      ]
    );
  }
}

/// Reusable labelled section header with an icon.
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.forestGreen),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.slateGrey,
            letterSpacing: 0.4
          )
        )
      ]
    );
  }
}