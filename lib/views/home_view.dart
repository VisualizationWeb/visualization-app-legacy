import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visualization_app/views/prefer_button/buttonful_frame.dart';
import 'package:visualization_app/views/prefer_chat/chat_frame.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _loading = true;
  bool _chatMode = false;

  @override
  void initState() {
    super.initState();

    _load();
  }

  void _load() async {
    setState(() {
      _loading = true;
    });

    var pref = await SharedPreferences.getInstance();

    setState(() {
      _chatMode = (pref.getBool('settings.chatMode') ?? false);
      _loading = false;
    });

    log('Using ' + (_chatMode ? 'Chat mode' : 'Buttonful mode'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualization App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context)
                .pushNamed('/settings')
                .then((_) => _load()),
          )
        ],
      ),
      body:
          _loading ? Container() : (_chatMode ? ChatFrame() : ButtonfulFrame()),
    );
  }
}
