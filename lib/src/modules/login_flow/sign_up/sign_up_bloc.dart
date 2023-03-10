import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/login_flow/login_flow_repository.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/shared/models/user_model.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/shared/utils/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final LoginFlowRepository repository;
  late final SharedPreferences sharedPreferences;  

  SignUpBloc({required this.repository, required this.sharedPreferences})
      : super(SignUpStateEmpty()) {
    on<OnCreateNewUserPressed>(createNewUser);
    on<OnSignUpEmpty>(signUpEmpty);
  }

  FirebaseAuth get _auth => FirebaseAuth.instance; // todo: create abstraction class
  FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance; // todo: create abstraction class

  Future<void> createNewUser(
      SignUpEvent event, Emitter<SignUpState> emitter) async {
    try {
      emitter(SignUpStateLoading());
      await Future.delayed(const Duration(seconds: 3));
      // authenticate new user on Firebase
      await _auth.createUserWithEmailAndPassword(
        email: event.getUser!.email, 
        password: event.getUser!.password,
        );      
      await _auth.currentUser!.updateDisplayName(event.getUser!.name);
      sharedPreferences.setString(SharedPreferencesKeys.userSession, event.getUser!.name);
      await _auth.currentUser!.sendEmailVerification();

      await repository.createUserData(
        user: UserModel(
          userModelID: _auth.currentUser!.uid, 
          userModelName: event.getUser!.name,
        ),
      );      
      emitter(SignUpStateSuccess());
    } catch (e, s) {
      _crashlytics.recordError(e, s);
      emitter(SignUpStateError(erro: e.toString()));
    }
  }

  signUpEmpty(SignUpEvent event, Emitter<SignUpState> emitter) async {
    emitter(SignUpStateEmpty());
  }
}
