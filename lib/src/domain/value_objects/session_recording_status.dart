/// High-level recording lifecycle for capture UI.
///
/// Maps to user-visible states only; native permission or pipeline details stay
/// in application/infrastructure layers.
enum SessionRecordingStatus {
  /// No active session; user can configure sources and start.
  idle,

  /// Session is starting (e.g. waiting on permissions or engines).
  preparing,

  /// Actively capturing and emitting events.
  recording,

  /// Capture paused; timeline may still be shown.
  paused,

  /// Session ended normally; host may reset to [idle].
  stopped,
}
