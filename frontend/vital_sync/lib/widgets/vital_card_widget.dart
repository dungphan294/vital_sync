// widgets/vital_card_widget.dart
import 'package:flutter/material.dart';
import '../models/vital_type_model.dart';

class VitalCardWidget extends StatelessWidget {
  final VitalTypeModel vitalType;
  final String value;
  final bool isCompact;
  final VoidCallback onTap;

  const VitalCardWidget({
    super.key,
    required this.vitalType,
    required this.value,
    this.isCompact = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isCompact ? 140 : 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const Spacer(),
              _buildValue(context),
              const SizedBox(height: 4),
              _buildLabel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: vitalType.iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            vitalType.icon,
            size: isCompact ? 20 : 24,
            color: vitalType.iconColor,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildValue(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: isCompact ? 24 : 32,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        children: [
          TextSpan(text: value),
          if (vitalType.unit.isNotEmpty)
            TextSpan(
              text: " ${vitalType.unit}",
              style: TextStyle(
                fontSize: isCompact ? 14 : 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Text(
      vitalType.label,
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
