import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/call_model.dart';
import '../utils/constants.dart';

class SignalingService {
  IO.Socket? _socket;

  void connect({required String userId}) {
    _socket = IO.io(Constants.socketUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    _socket!.onConnect((_) {
      _socket!.emit('presence:online', userId);
    });

    _socket!.connect();
  }

  void onIncomingCall(void Function(CallInfo) handler) {
    _socket?.on('call:incoming', (data) {
      final call = CallInfo(
        callerId: data['callerId'],
        callerName: data['callerName'],
        calleeId: data['calleeId'],
        calleeName: data['calleeName'],
        isVideo: data['isVideo'] ?? true,
        startedAt: DateTime.now(),
      );
      handler(call);
    });
  }

  void invite(CallInfo call) {
    _socket?.emit('call:invite', {
      'callerId': call.callerId,
      'callerName': call.callerName,
      'calleeId': call.calleeId,
      'calleeName': call.calleeName,
      'isVideo': call.isVideo,
    });
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
  }
} 