import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const kDuration600 = Duration(milliseconds: 600);
const kDuration400 = Duration(milliseconds: 400);

class FeedbackDialog extends StatefulWidget {
  final bool isSuccess;

  FeedbackDialog({@required this.isSuccess});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog>
    with TickerProviderStateMixin {
  AnimationController _enterAnimationController;
  AnimationController _lottieController;
  Animation<Offset> _animation;

  @override
  void initState() {
    _enterAnimationController = AnimationController(
      vsync: this,
      duration: kDuration400,
    )..forward();
    _animation = Tween<Offset>(begin: Offset(0, -2), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _enterAnimationController, curve: Curves.easeInOutBack));
    _lottieController = AnimationController(vsync: this);
    Future.delayed(kDuration400, () => _lottieController.forward());
    super.initState();
  }

  @override
  void dispose() {
    _enterAnimationController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    _enterAnimationController.reverse();
    Future.delayed(kDuration400, () {
      Navigator.pop(context);
    });
    return false;
  }

  void _exitDialog() {
    _enterAnimationController.reverse();
    Future.delayed(kDuration400, () {
      Navigator.pop(context);
    });
  }

  Container _bottomButtons(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: _exitDialog,
              color: Colors.black87,
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lottieAnimation() {
    if (widget.isSuccess) {
      return Lottie.asset('assets/error.json', controller: _lottieController,
          onLoaded: (composition) {
        _lottieController..duration = composition.duration;
      }, height: 150, width: 150, repeat: false);
    } else
      return Lottie.asset('assets/success.json',
          controller: _lottieController,
          addRepaintBoundary: true, onLoaded: (composition) {
        _lottieController..duration = composition.duration;
      }, height: 150, width: 150, repeat: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SlideTransition(
        position: _animation,
        child: GestureDetector(
          onTap: _exitDialog,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 60),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(5)),
              child: IgnorePointer(
                  ignoring: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _lottieAnimation(),
                      Divider(
                        color: Colors.black26,
                        thickness: 1,
                        endIndent: 60,
                        indent: 60,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          widget.isSuccess
                              ? 'Submitted successfully'
                              : 'Oops something went wrong',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      _bottomButtons(context),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
