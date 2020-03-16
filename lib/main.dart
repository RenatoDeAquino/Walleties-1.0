import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/core/view_models/home_view_model.dart';
import 'package:walleties/model/user_repository.dart';
import 'package:walleties/ui/screens/login.dart';
import 'package:walleties/ui/screens/widgets/logOutPopUp.dart';
import 'package:walleties/ui/values/colors.dart';
import 'package:walleties/ui/values/routes.dart' as Routes;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static InputBorder textFormLoginBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      borderSide: BorderSide(color: Color(0xFF63CBFF)));

  static InputBorder textFormLoginErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      borderSide: BorderSide(color: Colors.red));

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>(
            builder: (context) => HomeViewModel(),
          ),
          ChangeNotifierProvider<UserRepository>(
            builder: (context) => UserRepository.instance(),
          ),
        ],
        child: MaterialApp(
          title: 'Walleties App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xff34AD89),
            cursorColor: Color(0xFF63CBFF),
            accentColor: Color(0xFF63CBFF),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                color: primaryColor,
                fontFamily: "Book Antiqua",
                fontSize: 16,
              ),
              hintStyle: TextStyle(fontSize: 16),
              errorStyle: TextStyle(
                color: Colors.red,
                fontFamily: "Book Antiqua",
              ),
              errorBorder: textFormLoginErrorBorder,
              focusedErrorBorder: textFormLoginErrorBorder,
            ),
          ),
          home: MainScreen(),
        ),
      );
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return SplashScreen();
          return Scaffold(body: Text("SplashScreen"));
        }
        if ((!snapshot.hasData || snapshot.data == null)) {
          return LoginScreen();
        }
        // return HomeScreen();
        return SafeArea(
            child: Scaffold(
                body: FlatButton(
                    onPressed: () =>
                        showDialog(context: context, child: LogOutDialog()),
                    child: Text("Sair"))));
      },
    );
  }
}
