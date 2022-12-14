// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/login_flow/reset_password/reset_password_bloc.dart';

import '../../../routes/consts_routes.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/utils/consts.dart';
import '../../../shared/utils/mixins/validations_mixin.dart';
import '../../../shared/utils/shared_preferences_keys.dart';

import '../reset_password/reset_password_event.dart';
import 'custom_dialog/custom_dialog.dart';
import 'custom_input_form/text_rich_info.dart';
import 'custom_show_alert_dialog.dart';
import 'text_richinfo_create_account.dart';

class TextRichInfoForgotPassword extends StatefulWidget with ValidationMixin {
  const TextRichInfoForgotPassword({
    Key? key,
    required this.theme,
    required this.formkey,
    required this.inputClear,
  }) : super(key: key);

  final ThemeData theme;
  final GlobalKey<FormState> formkey;
  final Function()? inputClear;

  @override
  State<TextRichInfoForgotPassword> createState() =>
      _TextRichInfoForgotPasswordState();
}

class _TextRichInfoForgotPasswordState
    extends State<TextRichInfoForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return TextRichInfo(
      textLink: Text(
        Consts.textForgotPassword,
        style: widget.theme.textTheme.labelMedium,
      ),
      link: () async {
        showDialog(
          context: context,
          builder: (context) => const CustomShowAlertDialog(),
        ).then((email) async {
          if (email != null) {
            UserModel? user = await validEmailSharedPref(
              mail: email,
              sharedPreferencesKeys: SharedPreferencesKeys.users,
            );

            if (user != null) {
              final userResetPassword = await Modular.to
                  .pushNamed(ConstsRoutes.resetPasswordPage, arguments: user);

              if (userResetPassword != null) {
                Modular.get<ResetPasswordBloc>().add(OnResetPasswordPressed(
                    user: userResetPassword as UserModel));
              }
              widget.formkey.currentState!.reset();
              widget.inputClear;
            } else {
              return showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  title: Consts.textTitleTextRichinfoForgotPassword,
                  description: Consts.textDescriptionTextRichinfoForgotPassword,
                  wid1: TextRichInfoCreateAccount(
                    theme: widget.theme,
                    formkey: widget.formkey,
                    inputClear: widget.inputClear,
                  ),
                  buttonText: Consts.textCustomDialogButtonText,
                ),
              );
            }
          }
        });
      },
    );
  }
}