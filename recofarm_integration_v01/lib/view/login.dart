import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController userPwController = TextEditingController();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  bool showLoading = false;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Fluttertoast.showToast(
        msg: "로그인 완료!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        fontSize: 16.0,
      );

      setState(() {
        showLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        showLoading = false;
      });

      String errorMessage = "로그인 중 오류가 발생했습니다.";
      if (error.code == 'user-not-found') {
        errorMessage = "등록되지 않은 이메일입니다.";
      } else if (error.code == 'wrong-password') {
        errorMessage = "잘못된 비밀번호입니다.";
      } else {
        errorMessage = "오류: 이메일 혹은 비밀번호를 다시 입력하세요";
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);

        Fluttertoast.showToast(
          msg: "구글 로그인 완료!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          fontSize: 16.0,
        );

        setState(() {
          showLoading = false;
        });
      } else {
        // 구글 로그인 취소 시
        setState(() {
          showLoading = false;
        });
        Fluttertoast.showToast(
          msg: "구글 로그인이 취소되었습니다.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      setState(() {
        showLoading = false;
      });
      print(error);
      Fluttertoast.showToast(
        msg: "구글 로그인 중 오류가 발생했습니다.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          '로그인',
          style: TextStyle(
              fontSize: 50,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.onInverseSurface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                Image.asset(
                  "images/farmer.png",
                  height: 200,
                ),
                Row(
                  children: [
                    const Expanded(flex: 1, child: Text("아이디")),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          isDense: true,
                          hintText: "아이디를 입력하세요.",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: userIdController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(flex: 1, child: Text("비밀번호")),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          isDense: true,
                          hintText: "비밀번호를 입력하세요.",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: userPwController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/register');
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      child: const Text(
                        '회원가입하기',
                        style:
                            TextStyle(color: Color.fromARGB(255, 78, 101, 121)),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      child: const Text(
                        '로그인하기',
                      ),
                      onPressed: () async {
                        setState(() {
                          showLoading = true;
                        });

                        String userId = userIdController.text.trim();
                        String userPw = userPwController.text.trim();

                        if (userId.isEmpty || userPw.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "아이디와 비밀번호를 입력해 주세요.",
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            fontSize: 16.0,
                          );
                          setState(() {
                            showLoading = false;
                          });
                          return;
                        }

                        await signInWithEmailAndPassword(userId, userPw);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/findPw');
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)))),
                      child: const Text(
                        '비밀번호찾기',
                        style:
                            TextStyle(color: Color.fromARGB(255, 65, 154, 9)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "images/naver/btnW_.png",
                        width: 100,
                      ),
                    ),
                    // Google Sign-In Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          showLoading = true;
                        });
                        // 구글 로그인 메서드 호출
                        await signInWithGoogle();
                      },
                      icon: Image.asset(
                        "images/naver/btnW_.png",
                        width: 30,
                        height: 30,
                      ),
                      label: Text('구글 로그인'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Visibility(
              visible: showLoading,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 80,
                    color: Colors.white,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(width: 20),
                          Text("잠시만 기다려 주세요"),
                          SizedBox(width: 20),
                          Opacity(
                            opacity: 0,
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  mySQL_login(userId, UserPw) async {
    print("user id : $userId");
  }
}
