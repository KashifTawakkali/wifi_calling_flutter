import 'dart:async';

class AIService {
  Stream<String> startTranscriptionStream({required String callId}) {
    // In a real implementation, stream from a provider like Deepgram/AssemblyAI
    final controller = StreamController<String>();
    int i = 1;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      controller.add('AI caption $i');
      i++;
      if (i > 20) {
        timer.cancel();
        controller.close();
      }
    });
    return controller.stream;
  }
} 