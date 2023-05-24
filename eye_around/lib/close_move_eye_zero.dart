import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'home.dart';
import 'dart:async';
import 'close_eye_move_zero_start.dart';

class CloseMoveEyeZero extends StatefulWidget {
  const CloseMoveEyeZero({Key? key}) : super(key: key);

  @override
  State<CloseMoveEyeZero> createState() => _CloseMoveEyeZeroState();
}

class _CloseMoveEyeZeroState extends State<CloseMoveEyeZero> {


  Timer? _timer;
  bool _isRunning = false;
  int _timerCount = 60;
  String _buttonText = '시작';

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1b282a),
      appBar: AppBar(
        title: Text('화면을 가까이하고 눈 굴리기'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('화면을 가까이하고 눈 굴리기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Text('화면을 1m 거리 이내에 가까이 두고 아이콘을 따라 눈을 움직이세요',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: 120.0,
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     width: 1,
                  //     color: Colors.white,
                  //   ),
                  //   borderRadius: BorderRadius.circular(5.0),
                  // ),
                  child: Icon(
                      Icons.visibility,
                      size: 60.0,
                      color: Colors.green
                  ),
                ),
              ),

              SizedBox(
                height: 80.0,
              ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: LinearPercentIndicator(
              //     percent: 2 / 7,
              //     lineHeight: 10,
              //     backgroundColor: Colors.white,
              //     progressColor: Colors.blue,
              //     width: 360,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Text('$_timerCount',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: TextButton(
                  onPressed: (){
                    _isRunning = !_isRunning;

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CloseEyeMoveZeroStart()),
                    );

                    if(_isRunning){

                      setState(() {
                        // _timerCount = 60;
                        _buttonText = '정지';
                      });

                      _timer = Timer.periodic(Duration(seconds: 1), (timer){
                        if(_timerCount == 1){
                          _timer?.cancel();
                          Navigator.pop(context);
                        }

                        setState(() {
                          _timerCount--;

                        });
                      });
                    }
                    else {
                      _timer?.cancel();

                      setState(() {
                        _buttonText = '재개';
                      });
                    }
                  },
                  child: Text(
                    '$_buttonText',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    fixedSize: const Size(300, 40),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: TextButton(
                  onPressed: (){
                    _timer?.cancel();
                    Navigator.pop(context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => Home()),
                    // );
                  },
                  child: Text(
                    '끝',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    fixedSize: const Size(300, 40),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
