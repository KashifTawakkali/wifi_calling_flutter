import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/call_viewmodel.dart';
import '../models/call_model.dart';
import '../utils/app_routes.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CallInfo call = ModalRoute.of(context)!.settings.arguments as CallInfo;
    final callVM = Provider.of<CallViewModel>(context, listen: false);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 48, child: Text(call.callerName[0])),
            const SizedBox(height: 16),
            Text(call.callerName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(call.isVideo ? 'Video Call' : 'Audio Call'),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    callVM.rejectIncomingCall();
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.call_end),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    callVM.acceptIncomingCall(call);
                    Navigator.pushReplacementNamed(context, AppRoutes.call);
                  },
                  child: const Icon(Icons.call),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 