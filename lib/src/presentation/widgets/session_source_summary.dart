import 'package:flutter/material.dart';

/// Read-only summary of chosen capture sources (display, window, audio).
///
/// Labels are host-provided strings (e.g. "Built-in Retina Display", app name).
class SessionSourceSummary extends StatelessWidget {
  const SessionSourceSummary({
    super.key,
    required this.displayLabel,
    this.windowLabel,
    required this.audioLabel,
  });

  final String displayLabel;
  final String? windowLabel;
  final String audioLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainerHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sources',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _SourceRow(
              icon: Icons.desktop_mac_outlined,
              label: 'Display',
              value: displayLabel,
            ),
            if (windowLabel != null && windowLabel!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _SourceRow(
                icon: Icons.web_asset_outlined,
                label: 'Window',
                value: windowLabel!,
              ),
            ],
            const SizedBox(height: 10),
            _SourceRow(
              icon: Icons.mic_outlined,
              label: 'Audio',
              value: audioLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
