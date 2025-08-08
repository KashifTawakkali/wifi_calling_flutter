class WebRTCService {
  Future<void> initialize() async {}
  Future<void> startCall({required bool video}) async {}
  Future<void> endCall() async {}
  Future<void> mute(bool muted) async {}
  Future<void> switchCamera() async {}
} 