/*
 * Copyright (c) 2018-2022 Taner Sener
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'package:flutter/material.dart';

class ProgressModal {
  _Progress? _progress;
  late BuildContext _context;
  BuildContext? _cancelContext;
  late bool displayed;

  ProgressModal(BuildContext context) {
    _context = context;
    displayed = false;
  }

  void show(String message, {Function? cancelFunction}) {
    if (displayed) {
      return;
    }
    if (cancelFunction == null) {
      _progress = _Progress(message);
    } else {
      _progress = _Progress(message, cancelFunction: () {
        cancelFunction();
        hide();
      });
    }

    showDialog<dynamic>(
        context: _context,
        barrierDismissible: cancelFunction != null,
        builder: (BuildContext context) {
          _cancelContext = context;
          return WillPopScope(
              onWillPop: () async => cancelFunction != null,
              child: Dialog(
                  backgroundColor: Colors.white,
                  insetAnimationCurve: Curves.easeInOut,
                  insetAnimationDuration: const Duration(milliseconds: 100),
                  elevation: 10.0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: _progress));
        });

    displayed = true;
  }

  void update({String? message}) {
    if (displayed) {
      _progress!.update(message: message);
    }
  }

  void hide() {
    if (displayed && _cancelContext != null) {
      Navigator.of(_cancelContext!).pop();
      displayed = false;
    }
  }
}

class _Progress extends StatefulWidget {
  final _ProgressState _progressState;

  _Progress(String message, {Function? cancelFunction})
      : _progressState =
            _ProgressState(message, cancelFunction: cancelFunction);

  update({String? message}) {
    _progressState.update(message: message);
  }

  @override
  State<StatefulWidget> createState() {
    return _progressState;
  }
}

class _ProgressState extends State<_Progress> {
  String _message;
  final Function? _cancelFunction;

  _ProgressState(this._message, {Function? cancelFunction})
      : _cancelFunction = cancelFunction;

  update({String? message}) {
    if (message != null) {
      _message = message;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  _message,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ],
        ),
      ),
    );

    var cancelRow = Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 10),
        child: InkWell(
          onTap: () => _cancelFunction!(),
          child: Container(
            width: 100,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                'CANCEL',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      )
    ]);

    var widgets = _cancelFunction == null
        ? <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 10.0),
                const SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(width: 20.0),
                text,
                const SizedBox(width: 20.0)
              ],
            )
          ]
        : <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                width: 50.0,
                height: 80.0,
                child: const CircularProgressIndicator(),
              ),
            ]),
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  text,
                ],
              ),
              cancelRow
            ])
          ];

    return Container(
        padding: const EdgeInsets.all(20), child: Stack(children: widgets));
  }
}
