import 'package:flutter/material.dart';
import 'package:smart_pantry/animation/fade_animation.dart';
import 'package:smart_pantry/pages/api_response.dart';
import 'package:smart_pantry/pages/home/initial_page.dart';
import 'package:smart_pantry/pages/login/login_bloc.dart';
import 'package:smart_pantry/utils/alert.dart';
import 'package:smart_pantry/utils/nav.dart';

import 'email_page.dart';

class CreateAccountPass extends StatefulWidget {
  String email;

  CreateAccountPass(this.email);

  @override
  _CreateAccountPassState createState() => _CreateAccountPassState();
}

class _CreateAccountPassState extends State<CreateAccountPass> {

  String get email => widget.email;

  final _tSenha = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Center(
                    child: FadeAnimation(1.2,
                        Center(child: Image.asset('assets/logos/logo.png'))),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: FadeAnimation(
                      1.2,
                      Container(
                        width: 280,
                        child: Text(
                          "Digite uma senha para criar sua conta.",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: FadeAnimation(
                      1.5,
                      Container(
                        width: 280,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "",
                            hintText: "Digite sua senha",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                          controller: _tSenha,
                          validator: _validateSenha,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: FadeAnimation(
                      1.5,
                      Container(
                          height: 50,
                          width: 280,
                          child: StreamBuilder<bool>(
                              stream: _bloc.stream,
                              initialData: false,
                              builder: (context, snapshot) {
                                return RaisedButton(
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  onPressed: _onClickCreate,
                                  child: snapshot.data
                                      ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.white),
                                  )
                                      : Text(
                                    "CONTINUAR",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              })),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeAnimation(
                    1.6,
                    Container(
                      width: 300,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            push(context, EmailPage(), replace: true);
                          },
                          child: Text(
                            "Já tenho uma conta",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
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
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite sua senha";
    } else {
      return null;
    }
  }

  _onClickCreate() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    String senha = _tSenha.text;

    ApiResponse createResponse = await _bloc.create(email, senha);

    if (createResponse.ok) {
      ApiResponse loginResponse = await _bloc.login(email, senha);
      if(loginResponse.ok) {
        push(context, InitialPage(), replace: true);
      } else {
        alert(context, loginResponse.msg);
      }
    } else {
      alert(context, createResponse.msg);
    }
  }
}