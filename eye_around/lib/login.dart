import 'dart:convert';

import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'home.dart';
import 'api/api.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'model/user.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user/user_pref.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final _formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
      userLogin();
    }
  }

  TextEditingController controller_id = TextEditingController();
  TextEditingController controller_pw = TextEditingController();

  userLogin() async{
    try{
      var res = await http.post(
          Uri.parse(API.login),
          body: {
            'user_email' : controller_id.text.trim(),
            'user_password' : controller_pw.text.trim()
          });

      if(res.statusCode == 200){
        var resLogin = jsonDecode(res.body);
        if(resLogin['success'] == true){
          Fluttertoast.showToast(msg: '로그인하였습니다');
          User userInfo = User.fromJson(resLogin['userData']);

          await RememberUser.saveRememberuserInfo(userInfo);

          Get.to(LogIn());

          setState(() {
            controller_id.clear();
            controller_pw.clear();
          });
        }
        else {
          Fluttertoast.showToast(msg: '이메일과 비밀번호를 다시 확인하세요');
        }
      }
    }
    catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1b282a),
      appBar: AppBar(
        title: Text('로그인'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Center(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                                Icons.visibility,
                                size: 60.0,
                                color: Colors.blueGrey
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Eye - Around',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('로그인하세요',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 40.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Color(0xffe0d0d0),
                                  child: Icon(
                                    Icons.person,
                                    size: 40.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  width: 200.0,
                                  height: 40.0,
                                  child: TextFormField(
                                    key: ValueKey(1),
                                    validator: (value){
                                      if(value!.isEmpty || value.contains('@')){
                                        return null; //'유효한 이메일 형식을 입력해주세요';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      userEmail = value!;
                                    },
                                    controller: controller_id,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        //labelText: '이메일',
                                        hintText: '이메일을 입력하세요.'
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Color(0xffe0d0d0),
                                  child: Icon(
                                    Icons.key,
                                    size: 40.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  width: 200.0,
                                  height: 40.0,
                                  child: TextFormField(
                                    key: ValueKey(2),
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
                                        //labelText: '비밀번호',
                                        hintText: '비밀번호를 입력하세요.'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 40.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: (){

                                //id와 비밀번호 일치시
                                if(controller_id.text != '' && controller_pw.text != ''){
                                  _tryValidation();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(),
                                      settings: RouteSettings(name: '/')));
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (context) => Home()),
                                  // );
                                }
                                else if(controller_id.text == '' && controller_pw.text != ''){
                                  showSnackBar2(context);
                                }
                                else if(controller_id.text != '' && controller_pw.text == ''){
                                  showSnackBar3(context);
                                }
                                else{
                                  showSnackBar(context);
                                }

                              },
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                  fixedSize: const Size(300, 40),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40.0,
                                  margin: EdgeInsets.fromLTRB(0.0, 17.0, 0.0, 0.0),
                                  child: Text('아직 회원이 아니라면',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40.0,
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => SignUp()),
                                      );
                                    },
                                    child: Text(
                                      '가입하기',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      //fixedSize: const Size(80, 40),
                                      foregroundColor: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
      Text('이메일, 비밀번호가 일치하지 않습니다',
        textAlign: TextAlign.center, ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      )
  );

}

void showSnackBar2(BuildContext context){

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text('이메일이 일치하지 않습니다',
        textAlign: TextAlign.center, ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      )
  );

}

void showSnackBar3(BuildContext context){

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text('비밀번호가 일치하지 않습니다',
        textAlign: TextAlign.center, ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      )
  );

}