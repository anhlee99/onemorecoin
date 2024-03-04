import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart' as drive;
import 'package:http/http.dart' as http;

class GoogleDriveService {

  static final GoogleDriveService _singleton = GoogleDriveService._internal();

  factory GoogleDriveService() {
    return _singleton;
  }

  GoogleDriveService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveAppdataScope
    ],

  );

  GoogleSignInAccount? googleSignInAccount;

  Future<bool> loginWithGoogle() async {
    try {
      googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return false;
      }
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      return null;
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

  Future<void> uploadToHidden() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }

      final response = await driveApi.files.list(spaces: "appDataFolder");

    } finally {
    // Remove a dialog
    }
  }


  Future<void> uploadToHidden2() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return;
      }

      final file = await driveApi.files.insert(
        drive.File.fromJson({
          "title": "test.txt",
          "mimeType": "text/plain",
        }),
        uploadMedia: drive.Media(
          Stream.value(utf8.encode("Hello World")),
          11,
        ),
      );
      print(file.toJson());
    } finally {
      // Remove a dialog
    }
  }

}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = new http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}