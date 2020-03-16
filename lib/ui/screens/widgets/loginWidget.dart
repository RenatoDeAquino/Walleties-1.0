import 'package:flutter/material.dart';
import 'package:walleties/core/view_models/home_view_model.dart';
import 'package:walleties/main.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'package:walleties/model/user_repository.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final t = new GoogleTranslator();

  AnimationController _controller;
  Animation<Offset> _offset;

  int aux = 0;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _offset = Tween<Offset>(begin: Offset.zero, end: Offset(1.0, 0.0))
        .animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);
    UserRepository user = Provider.of<UserRepository>(context);

    _login() async {
      if (_formKey.currentState.validate()) {
        if (!await user.signIn(_emailController.text.replaceAll(" ", ""),
            _passwordController.text)) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          homeViewModel.flushbar(
              await t.translate(user.error, to: 'pt'), 4, context);
        }
      }
    }

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: List.generate(
                    2,
                    (index) => Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: index == 0 ? 10 : 8),
                            child: TextFormField(
                              focusNode:
                                  index == 0 ? _emailFocus : _passwordFocus,
                              controller: index == 0
                                  ? _emailController
                                  : _passwordController,
                              decoration: InputDecoration(
                                enabledBorder: MyApp.textFormLoginBorder,
                                focusedBorder: MyApp.textFormLoginBorder,
                                hintText: index == 0 ? "E-MAIL" : "SENHA",
                                suffixIcon: index == 1
                                    ? IconButton(
                                        icon: Icon(
                                          homeViewModel.showPasswordLogin
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () =>
                                            homeViewModel.updateShowPassword(0),
                                      )
                                    : null,
                              ),
                              style: TextStyle(
                                fontFamily: "Book Antiqua",
                                fontSize: 18,
                              ),
                              obscureText: index == 1
                                  ? homeViewModel.showPasswordLogin
                                  : false,
                              validator: (value) {
                                if (homeViewModel.isTextFieldChanging) {
                                  return null;
                                }
                                if (value.isEmpty) {
                                  return "Campo Vazio";
                                }
                                return null;
                              },
                              onChanged: (value) async {
                                if (aux == 1) {
                                  homeViewModel.updateIsTextFieldChanging(true);
                                  _formKey.currentState.validate();
                                  aux = 0;
                                }
                                if (_emailController.text != "" &&
                                    _passwordController.text != "") {
                                  homeViewModel.updateShowLoginButton(true);
                                  await _controller.reverse();
                                } else {
                                  await _controller.forward().then((aux) =>
                                      homeViewModel
                                          .updateShowLoginButton(false));
                                }
                              },
                              textInputAction: index == 1
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                              onFieldSubmitted: (value) async {
                                homeViewModel.updatePressedGoogleLogin(false);
                                homeViewModel.updateIsTextFieldChanging(false);
                                aux = 1;
                                if (index == 0) {
                                  _fieldFocusChange(
                                      context, _emailFocus, _passwordFocus);
                                } else {
                                  _login();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("Esqueci a senha :(");
                },
                child: Text(
                  "Esqueceu a senha?",
                  style: TextStyle(
                    color: homeViewModel.lightGreen,
                    fontSize: 16,
                    fontFamily: "Book Antiqua",
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: user.status == Status.Authenticating &&
                                  homeViewModel.pressedGoogleLogin
                              ? Center(child: CircularProgressIndicator())
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: OutlineButton(
                                    splashColor: Colors.grey,
                                    onPressed: () async {
                                      homeViewModel
                                          .updatePressedGoogleLogin(true);
                                      if (!await user.signInWithGoogle()) {
                                        if (user.error != '') {
                                          homeViewModel.flushbar(
                                              await t.translate(user.error,
                                                  to: 'pt'),
                                              4,
                                              context);
                                        }
                                      }
                                    },
                                    shape: CircleBorder(),
                                    highlightElevation: 0,
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "assets/google_logo.png",
                                        scale: 15,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: RaisedButton(
                              onPressed: () {
                                homeViewModel.updatePressedGoogleLogin(false);
                                homeViewModel.updateIsTextFieldChanging(false);
                                aux = 1;
                                _login();
                              },
                              color: homeViewModel.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Entrar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
