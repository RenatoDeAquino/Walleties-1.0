import 'package:flutter/material.dart';
import 'package:walleties/core/view_models/home_view_model.dart';
import 'package:walleties/main.dart';
import 'package:walleties/model/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class SignUpWidget extends StatefulWidget {
  SignUpWidget({Key key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final t = new GoogleTranslator();

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
    _confirmPasswordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);
    UserRepository user = Provider.of<UserRepository>(context);

    _signup() async {
      if (_formKey.currentState.validate()) {
        String aux = _passwordController.text;
        if (aux.contains(RegExp(
            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})"))) {
          if (!await user.signup(_emailController.text.replaceAll(" ", ""),
              _passwordController.text)) {
            homeViewModel.flushbar(
                await t.translate(user.error, to: 'pt'), 6, context);
          }
        } else {
          homeViewModel.flushbar(
              "A sua senha precisa conter no mínimo:\n- 8 caracteres\n- Um número\n- Uma letra minúscula\n- Uma letra maiúscula\n- Um caracter especial (@!#\$%^&*)",
              1500,
              context);
        }
      }
    }

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    controller: index == 0
                        ? _emailController
                        : index == 1
                            ? _passwordController
                            : _confirmPasswordController,
                    focusNode: index == 0
                        ? _emailFocus
                        : index == 1 ? _passwordFocus : _confirmPasswordFocus,
                    decoration: InputDecoration(
                      enabledBorder: MyApp.textFormLoginBorder,
                      focusedBorder: MyApp.textFormLoginBorder,
                      hintText: index == 0
                          ? "EMAIL"
                          : index == 1 ? "SENHA" : "CONFIRMAR SENHA",
                      suffixIcon: index == 1 || index == 2
                          ? IconButton(
                              icon: Icon(
                                index == 1
                                    ? homeViewModel.showPasswordSignUp
                                        ? Icons.visibility_off
                                        : Icons.visibility
                                    : homeViewModel.showConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () => index == 1
                                  ? homeViewModel.updateShowPassword(1)
                                  : homeViewModel.updateShowPassword(2),
                            )
                          : null,
                    ),
                    style: TextStyle(
                      fontFamily: "Book Antiqua",
                      fontSize: 18,
                    ),
                    obscureText: index == 1
                        ? homeViewModel.showPasswordSignUp
                        : index == 2
                            ? homeViewModel.showConfirmPassword
                            : false,
                    validator: (value) {
                      if (homeViewModel.isTextFieldChanging) {
                        return null;
                      }
                      if (value.isEmpty) {
                        return "Campo Vazio";
                      }
                      if (index != 0 &&
                          _passwordController.text != "" &&
                          _confirmPasswordController.text != "") {
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          return "Os campos de senha devem ser iguais";
                        }
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (aux == 1) {
                        homeViewModel.updateIsTextFieldChanging(true);
                        _formKey.currentState.validate();
                        aux = 0;
                      }
                    },
                    textInputAction: index == 2
                        ? TextInputAction.done
                        : TextInputAction.next,
                    onFieldSubmitted: (value) async {
                      homeViewModel.updateIsTextFieldChanging(false);
                      aux = 1;
                      if (index == 0) {
                        _fieldFocusChange(context, _emailFocus, _passwordFocus);
                      } else if (index == 1) {
                        _fieldFocusChange(
                            context, _passwordFocus, _confirmPasswordFocus);
                      } else {
                        _signup();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          height: MediaQuery.of(context).size.height * 0.07,
          child: RaisedButton(
            onPressed: () {
              homeViewModel.updateIsTextFieldChanging(false);
              aux = 1;
              _signup();
            },
            color: homeViewModel.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Registrar-se",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
