import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _loading = true;
  bool _chatMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      _chatMode = (prefs.getBool('settings.chatMode') ?? false);

      _loading = false;
    });
  }

  _saveSettings() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setBool('settings.chatMode', _chatMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return _loading
        ? Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          )
        : SettingsList(
            contentPadding: EdgeInsets.symmetric(vertical: 20),
            sections: [
              SettingsSection(
                title: '인터렉션',
                tiles: [
                  SettingsTile.switchTile(
                      title: '대화형 인터렉션 사용',
                      subtitle: _chatMode
                          ? '버튼 UI 없이 대화형 모드로 사용합니다.'
                          : '버튼 UI를 표시합니다.',
                      leading: const Icon(Icons.chat),
                      switchValue: _chatMode,
                      onToggle: (value) {
                        setState(() {
                          _chatMode = value;
                        });
                        _saveSettings();
                      }),
                ],
              )
            ],
          );
  }
}
