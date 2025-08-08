import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transcript_viewmodel.dart';
import '../viewmodels/call_viewmodel.dart';

class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranscriptViewModel>(
      builder: (context, tvm, _) {
        final entries = tvm.session?.entries ?? [];
        return Scaffold(
          appBar: AppBar(title: const Text('Transcript')),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.play_arrow),
            onPressed: () {
              final callId = context.read<CallViewModel>().currentCall?.calleeId ?? 'mock_call';
              tvm.startSession(callId: callId);
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Switch(
                      value: tvm.session?.translationEnabled ?? false,
                      onChanged: (v) => tvm.toggleTranslation(v),
                    ),
                    const Text('Translation'),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: tvm.session?.targetLanguage ?? 'en',
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'es', child: Text('Spanish')),
                        DropdownMenuItem(value: 'fr', child: Text('French')),
                      ],
                      onChanged: (v) => tvm.toggleTranslation(tvm.session?.translationEnabled ?? false, language: v),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final e = entries[index];
                    return ListTile(
                      dense: true,
                      title: Text(e.text),
                      subtitle: Text(e.timestamp.toIso8601String()),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 