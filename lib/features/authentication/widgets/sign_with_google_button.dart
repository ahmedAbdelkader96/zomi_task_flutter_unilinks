import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/features/authentication/widgets/auth_custom_button.dart';
import 'package:task/global/methods_helpers_functions/local_storage_helper.dart';
import 'package:task/global/methods_helpers_functions/toast.dart';
import 'package:task/global/navigation_routes/routes.dart';
import 'package:uni_links/uni_links.dart';
import '../bloc/auth_bloc.dart';

class SignWithGoogleButton extends StatefulWidget {
  const SignWithGoogleButton({super.key});

  @override
  State<SignWithGoogleButton> createState() => _SignWithGoogleButtonState();
}

class _SignWithGoogleButtonState extends State<SignWithGoogleButton> {
  StreamSubscription? _sub;
  String token = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initUniLinks();
  }

  Future<void> _initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) async {
      if (uri != null && uri.scheme == 'zomi') {
        final id = uri.queryParameters['id'];
        final token = uri.queryParameters['token'];
        final refreshToken = uri.queryParameters['refreshToken'];
        if (id != null && token != null && refreshToken != null) {
          await LocalStorageHelper.saveUserMainData(
              userId: id, token: token, refreshToken: refreshToken);

          if (mounted) {
            ToastClass.toast(
                context: context, data: "Verified successfully!", seconds: 3);
            Routes.mainViewScreen(context: context);
          }
        }
      }
    }, onError: (err) {});
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ErrorToSignWithGoogleState) {
          ToastClass.toast(context: context, data: state.message, seconds: 3);
          log(state.message);
        }

        // if (state is DoneToSignWithGoogleState) {
        //   ToastClass.toast(
        //       context: context, data: "Verified successfully!", seconds: 3);
        //   Routes.mainViewScreen(context: context);
        // }
      },
      builder: (context, state) {
        return AuthCustomButton(
            onPressed: () {
              context
                  .read<AuthenticationBloc>()
                  .add(SignWithGoogle(context: context));
            },
            imagePath: 'assets/images/google_colored.svg',
            title: 'Continue with Google');
      },
    );
  }
}
