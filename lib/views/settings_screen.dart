import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, svm, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.system, label: Text('System')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ],
                selected: {svm.themeMode},
                onSelectionChanged: (sel) => svm.setThemeMode(sel.first),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Enable live captions'),
                value: svm.liveCaptionsEnabled,
                onChanged: svm.setLiveCaptionsEnabled,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: svm.defaultTranslationLanguage,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'es', child: Text('Spanish')),
                  DropdownMenuItem(value: 'fr', child: Text('French')),
                ],
                onChanged: (v) => svm.setDefaultTranslationLanguage(v ?? 'en'),
                decoration: const InputDecoration(labelText: 'Default translation language'),
              ),
            ],
          ),
        );
      },
    );
  }
} 