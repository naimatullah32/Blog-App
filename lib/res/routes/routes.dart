

import 'package:blog_app/res/routes/routes_name.dart';
import 'package:get/get.dart';
import '../../view/home/home_view.dart';
import '../../view/splash_screen.dart';


class AppRoutes {

  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreen() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    // GetPage(
    //   name: RouteName.loginScreen,
    //   page: () => LoginScreen() ,
    //   transitionDuration: Duration(milliseconds: 250),
    //   transition: Transition.leftToRightWithFade ,
    // ) ,
    GetPage(
      name: RouteName.homeView,
      page: () => HomeScreen() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
  ];

}