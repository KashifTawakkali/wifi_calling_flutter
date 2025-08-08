import 'dart:async';
import 'package:flutter/material.dart';
import '../models/transcript_model.dart';

class TranscriptViewModel with ChangeNotifier {
  TranscriptSession? _session;
  StreamSubscription<String>? _mockStream;

  TranscriptSession? get session => _session;

  void startSession({required String callId}) {
    _session = TranscriptSession(callId: callId);
    notifyListeners();

    // Simulate incoming captions every second
    _mockStream?.cancel();
    final controller = StreamController<String>();
    _mockStream = controller.stream.listen(_onCaption);

    int counter = 1;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_session == null) {
        timer.cancel();
        controller.close();
        return;
      }
      controller.add('Caption line $counter');
      counter++;
      if (counter > 10) {
        timer.cancel();
        controller.close();
      }
    });
  }

  void _onCaption(String text) {
    if (_session == null) return;
    final entry = TranscriptEntry(timestamp: DateTime.now(), text: text);
    _session = _session!.addEntry(entry);
    notifyListeners();
  }

  void toggleTranslation(bool enabled, {String? language}) {
    if (_session == null) return;
    _session = TranscriptSession(
      callId: _session!.callId,
      entries: _session!.entries,
      translationEnabled: enabled,
      targetLanguage: language ?? _session!.targetLanguage,
    );
    notifyListeners();
  }

  void endSession() {
    _mockStream?.cancel();
    _session = null;
    notifyListeners();
  }
} 