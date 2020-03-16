import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/core/view_models/home_view_model.dart';
import 'package:walleties/ui/screens/Web/login_web.dart';
import 'package:walleties/ui/screens/Mobile/login_mob.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);
    return homeViewModel.getIsWeb() ? LoginScreenWeb() : LoginScreenMobile();
  }
}
