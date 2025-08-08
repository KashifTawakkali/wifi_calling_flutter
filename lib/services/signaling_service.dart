import 'package:socket_io_client/socket_io_client.dart' as io;

import '../utils/constants.dart';

class SignalingService {
  io.Socket? _socket;

  void connect({required String userId}) {
    _socket = io.io(Constants.socketUrl, io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    _socket!.onConnect((_) {
      _socket!.emit('presence:online', userId);
    });

    _socket!.connect();
  }

  void onIncomingCall(void Function(Map<String, dynamic>) handler) {
    _socket?.on('call:incoming', (data) => handler(Map<String, dynamic>.from(data)));
  }

  void onAnswer(void Function(Map<String, dynamic>) handler) {
    _socket?.on('call:answer', (data) => handler(Map<String, dynamic>.from(data)));
  }

  void onCandidate(void Function(Map<String, dynamic>) handler) {
    _socket?.on('call:candidate', (data) => handler(Map<String, dynamic>.from(data)));
  }

  void invite({
    required String fromUserId,
    required String toUserId,
    required bool isVideo,
    required String? sdpOffer,
  }) {
    _socket?.emit('call:invite', {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'isVideo': isVideo,
      'sdpOffer': sdpOffer,
    });
  }

  void sendAnswer({required String toUserId, required String sdpAnswer}) {
    _socket?.emit('call:answer', {
      'toUserId': toUserId,
      'sdpAnswer': sdpAnswer,
    });
  }

  void sendCandidate({required String toUserId, required Map<String, dynamic> candidate}) {
    _socket?.emit('call:candidate', {
      'toUserId': toUserId,
      'candidate': candidate,
    });
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
  }
} 