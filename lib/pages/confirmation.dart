import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:pills/main.dart';
import 'package:pills/repo/drug_repo.dart';
import 'package:slide_action/slide_action.dart';
import 'dart:math' as math;

import '../model/drug.dart';
import '../util/keyguard.dart';

class ConfirmationPageRoute extends MaterialPageRoute<void> {
  ConfirmationPageRoute(int drugId, bool isLocked)
      : super(
          builder: (context) {
            return ConfirmationPage(
              drugId: drugId,
              isLocked: isLocked,
            );
          },
        );
}

class ConfirmationPage extends StatefulWidget {
  final int drugId;
  final bool isLocked;
  const ConfirmationPage(
      {super.key, required this.drugId, required this.isLocked});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage>
    with SingleTickerProviderStateMixin {
  late final Drug drug;
  bool showCallScreen = true;
  Future<bool> isLocked = isKeyguardLocked();
  late final AnimationController _roatator;

  @override
  void initState() {
    super.initState();

    drug = drugRepo.getDrug(widget.drugId)!;
    showCallScreen = widget.isLocked;
    if(showCallScreen){
      FlutterRingtonePlayer.play(fromAsset: 'assets/ringtone.mp3', looping: true, volume: 1);
    }
    _roatator =
        AnimationController(vsync: this, lowerBound: 0, upperBound: math.pi * 2)
          ..repeat(
            period: Duration(seconds: 3),
          );
  }

  @override
  void dispose() {
    _roatator.dispose();
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showCallScreen ? _buildCall(context) : _buildMain(context);
  }

  Future<void> unlock() async {
    while(await dismissKeyguard());
    setState(() {
      showCallScreen = false;
    });
    FlutterRingtonePlayer.stop();
    // TODO: remove notification
  }

  Widget _buildCall(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Пришло время пить ${drug.name}',
            style: TextStyle(
              fontSize: 40,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width + 20,
            child: AnimatedBuilder(
              animation: _roatator,
              child: Image.asset('assets/shiza.png'),
              builder: (context, child) {
                return Transform.rotate(
                  angle: _roatator.value,
                  child: child,
                );
              },
            ),
          ),
          SlideAction(
            stretchThumb: true,
            thumbBuilder: (context, state) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: state.isPerformingAction ? Colors.grey : Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: state.isPerformingAction
                    ? const CupertinoActivityIndicator(
                  color: Colors.white,
                )
                    : const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              );
            },
            trackBuilder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Проведите, чтобы выпить",
                  ),
                ),
              );
            },
            action: (){
              print('Trying to unlock');
              unlock();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMain(BuildContext context) {
    return Scaffold(
      body: Text('Confirmation page'),
    );
  }
}
