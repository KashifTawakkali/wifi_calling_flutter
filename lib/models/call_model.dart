class CallInfo {
  final String callerId;
  final String callerName;
  final String calleeId;
  final String calleeName;
  final bool isVideo;
  final DateTime startedAt;

  CallInfo({
    required this.callerId,
    required this.callerName,
    required this.calleeId,
    required this.calleeName,
    required this.isVideo,
    required this.startedAt,
  });
}

enum CallStatus {
  ringing,
  connecting,
  connected,
  ended,
} 