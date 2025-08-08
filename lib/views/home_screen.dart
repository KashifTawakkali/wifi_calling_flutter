import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contacts_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/call_viewmodel.dart';
import '../models/user_model.dart';
import '../utils/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _signalingReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_signalingReady) {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      final callVM = Provider.of<CallViewModel>(context, listen: false);
      final userId = authVM.userId ?? 'me';
      callVM.initSignaling(userId: userId, onIncoming: (call) {
        if (!mounted) return;
        Navigator.of(context).pushNamed(AppRoutes.incomingCall, arguments: call);
      });
      _signalingReady = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsViewModel = Provider.of<ContactsViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final callVM = Provider.of<CallViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => contactsViewModel.fetchContacts(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.logout();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: contactsViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contactsViewModel.contacts.length,
              itemBuilder: (context, index) {
                final User contact = contactsViewModel.contacts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        contact.username[0].toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    title: Text(contact.username, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(contact.email ?? 'No email'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: () {
                            callVM.startOutgoingCall(
                              calleeId: contact.id,
                              calleeName: contact.username,
                              isVideo: false,
                            );
                            Navigator.of(context).pushNamed(AppRoutes.call);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.videocam, color: Colors.blue),
                          onPressed: () {
                            callVM.startOutgoingCall(
                              calleeId: contact.id,
                              calleeName: contact.username,
                              isVideo: true,
                            );
                            Navigator.of(context).pushNamed(AppRoutes.call);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}