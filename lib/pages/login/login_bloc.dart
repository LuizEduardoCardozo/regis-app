import 'dart:async';

import 'package:smart_pantry/firebase/firebase_service.dart';
import 'package:smart_pantry/pages/api_response.dart';
import 'package:smart_pantry/pages/login/login_api.dart';
import 'package:smart_pantry/utils/simple_bloc.dart';

class LoginBloc extends SimpleBloc<bool> {
  Future<ApiResponse> login(String login, String senha) async {
    add(true);

    ApiResponse response = await FirebaseService().login(login, senha);

    add(false);

    return response;
  }

  Future<ApiResponse> reset(String email, context) async {
    add(true);

    ApiResponse response = await LoginApi.resetPassword(email, context);

    add(false);

    return response;
  }

  Future<ApiResponse> create(String email, context) async {
    add(true);

    ApiResponse response = await LoginApi.create(email, context);

    add(false);

    return response;
  }
}
