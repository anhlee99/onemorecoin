import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onemorecoin/model/StorageStage.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' show json, jsonDecode, jsonEncode;

import '../services/auth_service.dart';




class LoginScreen extends StatefulWidget {

  static const String routeName = '/login';
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Account? _account;
  bool isAuth = false;

  final List<String> scopes = <String>[
    'email',
  ];
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId: '46715462293-cblefkoiav5sb6drk8crn90rfj04oq0d.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ]
  );


  Future<void> _handleSignInGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignInFacebook() async {
    try {
      final result = await FacebookAuth.i.login(
        permissions: ['email', 'public_profile'],
      );
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData(
          fields: "name,email,picture.width(200)",
        );
        setState(() {
          _account = Account(
            id: userData["id"],
            name: userData["name"],
            email: userData["email"],
            imageUrl: userData["picture"]["data"]["url"],
          );
        });
      }
    } catch (error) {
      print(error);
    }
  }

  // if use firebase_auth
  Future<UserCredential> firebaseSignInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> firebaseSignInWithGoogle() async {

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        setState(() {
          isAuth = true;
          _account = Account(
            id: user.uid,
            name: user.displayName ?? "",
            email: user.email ?? "",
            imageUrl: user.photoURL ?? "",
          );
        });
        context.loaderOverlay.hide();
        Navigator.pushReplacementNamed(context, "/home");
      }
    });

    // _googleSignIn.onCurrentUserChanged
    //     .listen((GoogleSignInAccount? account) async {
    //   // #docregion CanAccessScopes
    //   // In mobile, being authenticated means being authorized...
    //   bool isAuthorized = account != null;
    //   // However, on web...
    //   if (kIsWeb && account != null) {
    //     isAuthorized = await _googleSignIn.canAccessScopes(scopes);
    //   }
    //   // #enddocregion CanAccessScopes
    //
    //   // Now that we know that the user can access the required scopes, the app
    //   // can call the REST API.
    //
    //   if (isAuthorized) {
    //     setState(() {
    //       _account = Account(
    //         id: account!.id,
    //         name: account.displayName ?? "",
    //         email: account.email,
    //         imageUrl: account.photoUrl ?? "",
    //       );
    //     });
    //   }
    // });

    // _googleSignIn.signInSilently();
  }

  setDataUser(StorageStageProxy storageStage) async {
    if(_account != null){
      storageStage.saveInfoUser("user", _account.toString());
      storageStage.isLogin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var storageStage = context.read<StorageStageProxy>();
    setDataUser(storageStage);

    print("build login screen");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopScreenImage(screenImageName: 'home.jpg'),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const ScreenTitle(title: 'Hello'),
                      const Text(
                        'Welcome to Onemorecoin, nơi bạn quản lý chi tiêu của mình một cách hiệu quả!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Hero(
                        tag: 'login_btn',
                        child: CustomButton(
                          buttonText: 'Bỏ qua đăng nhập',
                          onPressed: () {
                            storageStage.isLogin = true;
                            Navigator.pushReplacementNamed(context, "/home");
                          },
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // Hero(
                      //   tag: 'signup_btn',
                      //   child: CustomButton(
                      //     buttonText: 'Sign Up',
                      //     isOutlined: true,
                      //     onPressed: () {
                      //       // Navigator.pushNamed(context, SignUpScreen.id);
                      //     },
                      //   ),
                      // ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'Đăng nhập bằng tài khoản',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              // _handleSignInFacebook();
                              firebaseSignInWithFacebook();
                            },

                            icon: CircleAvatar(
                              radius: 20,
                              child: Image.asset(
                                  'assets/images/icons/facebook.png'),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              // _handleSignInGoogle();
                              context.loaderOverlay.show();
                              firebaseSignInWithGoogle();
                              // AuthService().signInWithGoogle();
                            },

                            icon: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                              child:
                              Image.asset('assets/images/icons/google.png'),
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: CircleAvatar(
                          //     radius: 20,
                          //     child: Image.asset(
                          //         'assets/images/icons/linkedin.png'),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class Account {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  Account({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['picture'],
    );
  }

  factory Account.fromString(String data) {
    var json = jsonDecode(data);
    return Account(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['picture'],
    );
  }

  @override
  String toString() {
    return jsonEncode({
      'id': id,
      'name': name,
      'email': email,
      'picture': imageUrl,
    });
  }

}