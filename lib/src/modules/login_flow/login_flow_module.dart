// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/home/home_page.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/login_flow/reset_password/reset_password_page.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/login_flow/sign_up/sign_up_page.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/login_flow/splash_screen/splash_screen_bloc.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/routes/consts_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../not_found_page/not_found_page.dart';
import 'login/login_page.dart';

class LoginFlowModule extends Module { // equivalent to AutenthicationModule

  final SharedPreferences sharedPref;

  LoginFlowModule({
    required this.sharedPref,
  });
  
  @override
  List<Bind<Object>> get binds => [
    Bind.singleton((i) => SplashScreenBloc(repository: i(), sharedPreferences: sharedPref)),
  ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(ConstsRoutes.rootRoute,
            child: (context, args) => const LoginPage()),
        ChildRoute(ConstsRoutes.signUpPage,
            child: (context, args) => const SignUpPage()),
        ChildRoute(ConstsRoutes.homePage,
            child: (context, args) => const HomePage()),
        ChildRoute(ConstsRoutes.resetPasswordPage,
            child: (context, args) => const ResetPasswordPage()),
        WildcardRoute(child: (context, args) => const NotFoundPage()),
      ];
}
