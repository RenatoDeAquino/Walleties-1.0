import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/core/view_models/home_view_model.dart';
import 'package:walleties/ui/screens/widgets/loginWidget.dart';
import 'package:walleties/ui/screens/widgets/signUpWidget.dart';

class LoginScreenWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            title: Text(
              "Walleties",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Bookman Old Style',
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Padding(
              padding: EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/walleties.png",
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RaisedButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: homeViewModel.blue,
                      child: Text(
                        "Registre-se",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          body: Row(
            children: <Widget>[
              Container(
                color: homeViewModel.lightBlue,
                height: height,
                width: MediaQuery.of(context).size.width * 0.35,
                child: FractionallySizedBox(
                  widthFactor: 0.55,
                  heightFactor: 0.55,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: "Entre com sua conta ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Book Antiqua",
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF444444),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Walleties",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: "Bookman Old Style",
                                          fontWeight: FontWeight.bold,
                                          color: homeViewModel.darkGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                TabBar(
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
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Center(child: SignUpWidget()),
                                Center(child: LoginWidget()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Image.asset(
                      "assets/inicio1.jpg",
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        heightFactor: 0.2,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 70),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.zero,
                                  bottomRight: Radius.zero),
                            ),
                            color: Colors.white,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: Colors.grey),
                                    ),
                                    color: Color(0xffF6F8FC),
                                  ),
                                  height: double.infinity,
                                  child: Image.asset(
                                    "assets/inicioIcon1.png",
                                    scale: 7,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      "Utilize nossa função de informação conjunta para saber sobre o papel geral de todos os seus cartões de crédito.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xff5D5D5D),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(flex: 3, child: Container()),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  5,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SizedBox(
                                      width: 12,
                                      child: RaisedButton(
                                        onPressed: () {},
                                        shape: CircleBorder(),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
