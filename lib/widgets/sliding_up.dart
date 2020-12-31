import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUp extends StatefulWidget {
  final Widget body;
  final Widget panel;
  final Widget footer;
  final PanelController controller;

  SlidingUp({Key key, this.body, this.panel, this.footer, this.controller})
      : super(key: key);

  @override
  _SlidingUpState createState() => _SlidingUpState();
}

class _SlidingUpState extends State<SlidingUp> {
  static const double _handleHeight = 50.0;
  static const double _panelHeightClosed = _handleHeight;
  double _panelHeightOpen;

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * 0.8;

    return SlidingUpPanel(
      controller: widget.controller,
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      defaultPanelState: PanelState.OPEN,
      parallaxEnabled: true,
      parallaxOffset: 1,
      body: widget.body,
      backdropEnabled: true,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      panel: Column(children: [
        SizedBox(
          height: 18.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(18.0))),
            ),
          ],
        ),
        SizedBox(
          height: 24.0,
        ),
        widget.panel
      ]),
      footer: widget.footer,
    );
  }
}
