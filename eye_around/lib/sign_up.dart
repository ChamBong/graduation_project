import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_project/main.dart';
import 'api/api.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'model/user.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
      checkUserEmail();
    }
  }

  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_email = TextEditingController();
  TextEditingController controller_pw = TextEditingController();
  TextEditingController controller_pwConfirm = TextEditingController();

  checkUserEmail() async{
    try{
      var response = await http.post(
          Uri.parse(API.validateEmail),
          body: {
            'user_email' : controller_email.text.trim()
          }
      );

      if(response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if(responseBody['existEmail'] == true){
          Fluttertoast.showToast(
            msg: "이미 존재하는 이메일입니다. 다른 이메일을 입력하세요.",
          );
        }
        else {
          saveInfo();
        }
      }
    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveInfo() async{
    User userModel = User(
        1,
        controller_name.text.trim(),
        controller_email.text.trim(),
        controller_pw.text.trim()
    );

    try{
      var res = await http.post(
          Uri.parse(API.signup),
          body: userModel.toJson()
      );

      if(res.statusCode == 200){
        var resSignup = jsonDecode(res.body);
        if(resSignup['success'] == true){
          Fluttertoast.showToast(msg: '회원가입이 되었습니다.');
          setState(() {
            controller_name.clear();
            controller_email.clear();
            controller_pw.clear();
          });
        }
        else {
          Fluttertoast.showToast(msg: '오류가 발생했습니다. 다시 시도해주세요');
        }
      }
    }
    catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  String inputName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1b282a),
      appBar: AppBar(
        title: Text('회원가입'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.teal,
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(
                          color: Colors.teal,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                          child: Text('Hello,',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                          child: Text('Let`s Eye - Around!',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('회원가입',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Text('이름',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Container(
                            color: Colors.white,
                            width: 380.0,
                            height: 40.0,
                            child: TextFormField(
                              key: ValueKey(1),
                              validator: (value){
                                if(value!.isEmpty || value.length < 2){
                                  return null; //'2자 이상 입력하세요';
                                }
                                return null;
                              },
                              onSaved: (value){
                                userName = value!;
                              },
                              controller: controller_name,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: '이름',
                                hintText: '한글 2자 이상',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Text('이메일',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Container(
                            color: Colors.white,
                            width: 380.0,
                            height: 40.0,
                            child: TextFormField(
                              key: ValueKey(2),
                              validator: (value){
                                if(value!.isEmpty || !value.contains('@')){
                                  return null; //'유효한 이메일 형식을 입력해주세요';
                                }
                                return null;
                              },
                              onSaved: (value){
                                userEmail = value!;
                              },
                              controller: controller_email,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: '이메일',
                                hintText: '인증 가능한 이메일 주소',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Text('비밀번호',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Container(
                            color: Colors.white,
                            width: 380.0,
                            height: 40.0,
                            child: TextFormField(
                              key: ValueKey(3),
                              validator: (value){
                                if(value!.isEmpty || value.length < 8){
                                  return null; //'8자 이상의 패스워드를 입력하세요';
                                }
                                return null;
                              },
                              onSaved: (value){
                                userPassword = value!;
                              },
                              controller: controller_pw,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: '비밀번호',
                                hintText: '8자 이상',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Text('비밀번호 확인',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Container(
                            color: Colors.white,
                            width: 380.0,
                            height: 40.0,
                            child: TextFormField(
                              key: ValueKey(4),
                              controller: controller_pwConfirm,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                // labelText: '비밀번호 확인',
                                hintText: '8자 이상',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextButton(
                              onPressed: (){

                                if(controller_name.text != '' && controller_email.text != '' &&
                                    controller_pw.text != '' && controller_pwConfirm.text == controller_pw.text){
                                  _tryValidation();
                                  Navigator.pop(context);
                                }
                                else if(controller_name.text == ''){
                                  showSnackBar(context);
                                }
                                else if(controller_email.text == ''){
                                  showSnackBar2(context);
                                }
                                else if(controller_pw.text == ''){
                                  showSnackBar3(context);
                                }
                                else if(controller_pwConfirm.text != controller_pw.text){
                                  showSnackBar4(context);
                                }
                                else{
                                  showSnackBar5(context);
                                }
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(builder: (context) => LogIn()),
                                // );
                              },
                              child: Text(
                                '회원가입',
                                style: TextStyle(
                                    fontSize: 16.0
                                ),
                              ),
                              style: TextButton.styleFrom(
                                fixedSize: const Size(380, 40),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void showSnackBar(BuildContext context){

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text('이름을 입력하세요',
        textAlign: TextAlign.center, ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      )
  );

}

void showSnackBar2(BuildContext context){

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text('이메일을 입력하세요',
        textAlign: TextAlign.center, ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      )
  );

}

void showSnackBar3(BuildContext context){

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text('비밀번호를 입력하세요',
        textAlign: TextAlign.center, ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      )
  );

}

void showSnackBar4(BuildContext context){

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text('비밀번호가 같지 않습니다',
        textAlign: TextAlign.center, ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      )
  );

}

void showSnackBar5(BuildContext context){

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text('회원가입을 진행할 수 없습니다',
        textAlign: TextAlign.center, ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      )
  );

}