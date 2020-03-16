import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/core/view_models/home_view_model.dart';
import 'package:walleties/model/user_repository.dart';
import 'package:walleties/ui/screens/widgets/loginWidget.dart';
import 'package:walleties/ui/screens/widgets/signUpWidget.dart';

class LoginScreenMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);
    UserRepository user = Provider.of<UserRepository>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Column(
              children: List.generate(
                3,
                (index) => Expanded(
                  flex: 1,
                  child: Container(
                    color: index == 0
                        ? homeViewModel.blue
                        : index == 1
                            ? homeViewModel.darkGreen
                            : homeViewModel.lightGreen,
                  ),
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.75,
                heightFactor: 0.6,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/walleties.png",
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Walleties",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Bookman Old Style",
                                fontWeight: FontWeight.bold,
                                color: homeViewModel.darkGreen,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TabBar(
                          indicatorColor: homeViewModel.lightGreen,
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 50),
                          tabs: List.generate(
                            2,
                            (index) => Tab(
                              child: Text(
                                index == 0 ? "Registre-se" : "Entrar",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: "Book Antiqua",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TabBarView(
                            children: [
                              SignUpWidget(),
                              LoginWidget(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            user.status == Status.Authenticating &&
                    !homeViewModel.pressedGoogleLogin
                ? Center(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
