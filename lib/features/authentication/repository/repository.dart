import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:task/features/authentication/models/user_model.dart';
import 'package:task/features/authentication/repository/irepository.dart';

class AuthRepository implements IAuthRepository {
  @override
  Future<UserModel?> fetchUserData({required String id}) async {
    try {
      var url = Uri.parse('${dotenv.env['end_point']}/user?id=$id');
      var res = await http.get(url).timeout(const Duration(seconds: 60));
      var data = jsonDecode(res.body);
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<http.Response> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      var body = {
        "name": name,
        "email": email,
        "password": password,
      };

      var url = Uri.parse('${dotenv.env['end_point']}/user/signup');
      var res =
          await http.post(url, body: body).timeout(const Duration(seconds: 60));

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<http.Response> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var body = {
        "email": email,
        "password": password,
      };
      var url = Uri.parse('${dotenv.env['end_point']}/user/login');
      var res =
          await http.post(url, body: body).timeout(const Duration(seconds: 60));
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithGoogle({required BuildContext context}) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse(
            'https://zomi-task-nodejs-three.vercel.app/user/login/google'),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<http.Response> renewToken({required String refreshToken}) async {
    try {
      var body = {
        "refreshToken": refreshToken,
      };
      var url = Uri.parse('${dotenv.env['end_point']}/user/renew_token');
      var res =
          await http.post(url, body: body).timeout(const Duration(seconds: 60));
      return res;
    } catch (e) {
      rethrow;
    }
  }











}
