// widgets/connection_status_widget.dart
import 'package:flutter/material.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final String statusText;
  final Color statusColor;
  final VoidCallback onManualRefresh;

  const ConnectionStatusWidget({
    super.key,
    required this.isConnected,
    required this.isScanning,
    required this.statusText,
    required this.statusColor,
    required this.onManualRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatusIndicator(context),
          const SizedBox(height: 16),
          if (isScanning) _buildScanningIndicator(context),
          if (!isConnected && !isScanning) _buildScanButton(context),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildScanningIndicator(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildScanButton(BuildContext context) {
    return TextButton.icon(
      onPressed: onManualRefresh,
      icon: const Icon(Icons.bluetooth_searching_rounded, size: 20),
      label: const Text("Scan for Device"),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
