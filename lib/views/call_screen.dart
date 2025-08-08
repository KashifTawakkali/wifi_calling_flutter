import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/call_viewmodel.dart';
import '../models/call_model.dart';
import '../utils/app_routes.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CallViewModel>(
      builder: (context, callVM, _) {
        final connected = callVM.status == CallStatus.connected;
        return Scaffold(
          appBar: AppBar(
            title: Text(connected ? 'In Call' : 'Ringing...'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                callVM.endCall();
                Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
              },
            ),
          ),
          body: Stack(
            children: [
              Center(
                child: Icon(
                  callVM.currentCall?.isVideo == true ? Icons.videocam : Icons.call,
                  size: 120,
                  color: Colors.blueGrey,
                ),
              ),
              if (callVM.showCaptions)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Captions on (mock overlay)',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: callVM.toggleMute,
                  icon: Icon(callVM.isMuted ? Icons.mic_off : Icons.mic),
                ),
                IconButton(
                  onPressed: callVM.switchCamera,
                  icon: const Icon(Icons.cameraswitch),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    callVM.endCall();
                    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
                  },
                  child: const Icon(Icons.call_end),
                ),
                IconButton(
                  onPressed: callVM.toggleCaptions,
                  icon: Icon(callVM.showCaptions ? Icons.closed_caption_disabled : Icons.closed_caption),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.transcript);
                  },
                  icon: const Icon(Icons.subtitles),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 