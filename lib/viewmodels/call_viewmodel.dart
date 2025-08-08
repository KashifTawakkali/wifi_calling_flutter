import 'package:flutter/material.dart';
import '../models/call_model.dart';
import '../services/signaling_service.dart';

class CallViewModel with ChangeNotifier {
  final SignalingService _signaling = SignalingService();
  CallInfo? _currentCall;
  CallStatus _status = CallStatus.ended;
  bool _isMuted = false;
  bool _isFrontCamera = true;
  bool _showCaptions = false;

  CallInfo? get currentCall => _currentCall;
  CallStatus get status => _status;
  bool get isMuted => _isMuted;
  bool get isFrontCamera => _isFrontCamera;
  bool get showCaptions => _showCaptions;

  void initSignaling({required String userId, required void Function(CallInfo) onIncoming}) {
    _signaling.connect(userId: userId);
    _signaling.onIncomingCall((call) {
      _currentCall = call;
      _status = CallStatus.ringing;
      notifyListeners();
      onIncoming(call);
    });
  }

  void startOutgoingCall({
    required String calleeId,
    required String calleeName,
    bool isVideo = true,
  }) {
    _currentCall = CallInfo(
      callerId: 'me',
      callerName: 'Me',
      calleeId: calleeId,
      calleeName: calleeName,
      isVideo: isVideo,
      startedAt: DateTime.now(),
    );
    _status = CallStatus.ringing;
    notifyListeners();

    _signaling.invite(_currentCall!);

    Future.delayed(const Duration(seconds: 2), () {
      _status = CallStatus.connected;
      notifyListeners();
    });
  }

  void acceptIncomingCall(CallInfo call) {
    _currentCall = call;
    _status = CallStatus.connected;
    notifyListeners();
  }

  void rejectIncomingCall() {
    _currentCall = null;
    _status = CallStatus.ended;
    notifyListeners();
  }

  void endCall() {
    _status = CallStatus.ended;
    _currentCall = null;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void switchCamera() {
    _isFrontCamera = !_isFrontCamera;
    notifyListeners();
  }

  void toggleCaptions() {
    _showCaptions = !_showCaptions;
    notifyListeners();
  }
} 