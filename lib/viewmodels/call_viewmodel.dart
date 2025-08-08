import 'package:flutter/material.dart';
import '../models/call_model.dart';
import '../services/signaling_service.dart';
import '../services/webrtc_service.dart';

class CallViewModel with ChangeNotifier {
  final SignalingService _signaling = SignalingService();
  final WebRTCService _webrtc = WebRTCService();
  CallInfo? _currentCall;
  CallStatus _status = CallStatus.ended;
  bool _isMuted = false;
  bool _isFrontCamera = true;
  bool _showCaptions = false;
  String? _myUserId;

  CallInfo? get currentCall => _currentCall;
  CallStatus get status => _status;
  bool get isMuted => _isMuted;
  bool get isFrontCamera => _isFrontCamera;
  bool get showCaptions => _showCaptions;
  get localRenderer => _webrtc.localRenderer;
  get remoteRenderer => _webrtc.remoteRenderer;

  void initSignaling({required String userId, required void Function(CallInfo) onIncoming}) {
    _myUserId = userId;
    _signaling.connect(userId: userId);
    _signaling.onIncomingCall((data) async {
      // Incoming: data has fromUserId, isVideo, sdpOffer
      _currentCall = CallInfo(
        callerId: data['fromUserId'],
        callerName: 'Remote',
        calleeId: userId,
        calleeName: 'Me',
        isVideo: data['isVideo'] ?? true,
        startedAt: DateTime.now(),
      );
      _status = CallStatus.ringing;
      notifyListeners();
      onIncoming(_currentCall!);
    });
    _signaling.onAnswer((data) async {
      final sdp = data['sdpAnswer'] as String?;
      if (sdp != null) {
        await _webrtc.setRemoteDescription(sdp, 'answer');
        _status = CallStatus.connected;
        notifyListeners();
      }
    });
    _signaling.onCandidate((data) async {
      final cand = Map<String, dynamic>.from(data['candidate'] as Map);
      await _webrtc.addCandidate(cand);
    });
  }

  Future<void> startOutgoingCall({
    required String calleeId,
    required String calleeName,
    bool isVideo = true,
  }) async {
    _currentCall = CallInfo(
      callerId: _myUserId ?? 'me',
      callerName: 'Me',
      calleeId: calleeId,
      calleeName: calleeName,
      isVideo: isVideo,
      startedAt: DateTime.now(),
    );
    _status = CallStatus.connecting;
    notifyListeners();

    await _webrtc.initialize();
    await _webrtc.startLocalMedia(video: isVideo);
    await _webrtc.setupPeerConnection();
 
     final offerSdp = await _webrtc.createOffer();
    _signaling.invite(
      fromUserId: _myUserId ?? 'me',
      toUserId: calleeId,
      isVideo: isVideo,
      sdpOffer: offerSdp,
    );
  }

  Future<void> acceptIncomingCall() async {
    if (_currentCall == null) return;
    await _webrtc.initialize();
    await _webrtc.startLocalMedia(video: _currentCall!.isVideo);
    await _webrtc.setupPeerConnection();
    // Set remote offer from signaling
    // This requires we store the last offer; for brevity, we expect it to be resent via onIncomingCall
  }

  void acceptWithOffer(String sdpOffer, String fromUserId) async {
    _status = CallStatus.connecting;
    notifyListeners();
    await _webrtc.initialize();
    await _webrtc.startLocalMedia(video: _currentCall?.isVideo ?? true);
    await _webrtc.setupPeerConnection();
    await _webrtc.setRemoteDescription(sdpOffer, 'offer');
    final answer = await _webrtc.createAnswer();
    _signaling.sendAnswer(toUserId: fromUserId, sdpAnswer: answer);
    _status = CallStatus.connected;
    notifyListeners();
  }

  void sendCandidate(String toUserId, Map<String, dynamic> candidate) {
    _signaling.sendCandidate(toUserId: toUserId, candidate: candidate);
  }

  void acceptIncomingCallLegacy(CallInfo call) {
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
    _webrtc.endCall();
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _webrtc.mute(_isMuted);
    notifyListeners();
  }

  void switchCamera() {
    _isFrontCamera = !_isFrontCamera;
    _webrtc.switchCamera();
    notifyListeners();
  }

  void toggleCaptions() {
    _showCaptions = !_showCaptions;
    notifyListeners();
  }
} 