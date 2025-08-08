class TranscriptEntry {
  final DateTime timestamp;
  final String text;
  final String? language;

  TranscriptEntry({
    required this.timestamp,
    required this.text,
    this.language,
  });
}

class TranscriptSession {
  final String callId;
  final List<TranscriptEntry> entries;
  final bool translationEnabled;
  final String? targetLanguage;

  TranscriptSession({
    required this.callId,
    List<TranscriptEntry>? entries,
    this.translationEnabled = false,
    this.targetLanguage,
  }) : entries = entries ?? [];

  TranscriptSession addEntry(TranscriptEntry entry) {
    return TranscriptSession(
      callId: callId,
      entries: [...entries, entry],
      translationEnabled: translationEnabled,
      targetLanguage: targetLanguage,
    );
  }
} 