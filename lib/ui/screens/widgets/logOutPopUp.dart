import 'package:flutter/material.dart';
import 'package:walleties/core/view_models/home_view_model.dart';
import 'package:walleties/model/user_repository.dart';
import 'package:provider/provider.dart';

class LogOutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text("Sair"),
      actions: List.generate(
        2,
        (index) => FlatButton(
            splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
            child: Text(
              index == 0 ? "Confirmar" : "Cancelar",
              style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
                // fontFamily: Theme.of(context).textTheme.body1.fontFamily,
                fontSize: 16,
              ),
            ),
            onPressed: () async {
              if (index == 1) {
                Navigator.of(context).pop();
              } else {
                homeViewModel.updateShowLoginButton(false);
                Navigator.of(context).pop();
                Provider.of<UserRepository>(context).signOut();
              }
            }),
      ),
    );
  }
}
