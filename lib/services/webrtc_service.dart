import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _pc;
  MediaStream? _localStream;
  final _remoteStream = RTCVideoRenderer();
  final _localRenderer = RTCVideoRenderer();
  void Function(RTCIceCandidate)? _onIceCandidate;

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteStream;

  Future<void> initialize() async {
    await _localRenderer.initialize();
    await _remoteStream.initialize();
  }

  void onIceCandidate(void Function(RTCIceCandidate) handler) {
    _onIceCandidate = handler;
  }

  Future<void> dispose() async {
    await _localRenderer.dispose();
    await _remoteStream.dispose();
    await _localStream?.dispose();
    await _pc?.close();
  }

  Future<void> startLocalMedia({required bool video}) async {
    final mediaConstraints = {
      'audio': true,
      'video': video
          ? {
              'facingMode': 'user',
              'width': {'ideal': 1280},
              'height': {'ideal': 720},
              'frameRate': {'ideal': 30},
            }
          : false,
    };
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;
  }

  Future<void> setupPeerConnection() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };
    _pc = await createPeerConnection(config, {});
    if (_localStream != null) {
      for (var track in _localStream!.getTracks()) {
        await _pc!.addTrack(track, _localStream!);
      }
    }
    _pc!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        _remoteStream.srcObject = event.streams.first;
      }
    };
    _pc!.onIceCandidate = (RTCIceCandidate candidate) {
      if (_onIceCandidate != null) _onIceCandidate!(candidate);
    };
  }

  Future<String> createOffer() async {
    final offer = await _pc!.createOffer();
    await _pc!.setLocalDescription(offer);
    return offer.sdp!;
  }

  Future<String> createAnswer() async {
    final answer = await _pc!.createAnswer();
    await _pc!.setLocalDescription(answer);
    return answer.sdp!;
  }

  Future<void> setRemoteDescription(String sdp, String type) async {
    final desc = RTCSessionDescription(sdp, type);
    await _pc!.setRemoteDescription(desc);
  }

  Future<void> addCandidate(Map<String, dynamic> cand) async {
    final candidate = RTCIceCandidate(cand['candidate'], cand['sdpMid'], cand['sdpMLineIndex']);
    await _pc!.addCandidate(candidate);
  }

  Future<void> endCall() async {
    await _pc?.close();
    await _localStream?.dispose();
    _pc = null;
    _localStream = null;
  }

  Future<void> mute(bool muted) async {
    _localStream?.getAudioTracks().forEach((t) => t.enabled = !muted);
  }

  Future<void> switchCamera() async {
    final tracks = _localStream?.getVideoTracks();
    if (tracks != null && tracks.isNotEmpty) {
      await Helper.switchCamera(tracks.first);
    }
  }
} 