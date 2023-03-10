// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/routes/consts_routes.dart';

import '../../../shared/utils/consts.dart';
import '../../../shared/utils/mixins/validations_mixin.dart';
import 'custom_input_form/custom_text_form_field.dart';
import 'custom_input_form/input_clear.dart';

class CustomShowAlertDialog extends StatefulWidget {
  const CustomShowAlertDialog({super.key});

  @override
  State<CustomShowAlertDialog> createState() => _CustomShowAlertDialogState();
}

class _CustomShowAlertDialogState extends State<CustomShowAlertDialog> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final formValidVN = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    // configura o  AlertDialog
    return AlertDialog(
      title: const Text(Consts.textTitleCustomShowAlertDialog),
      content: Form(
        key: formkey,
        //Habilta de desabilita o botão
        onChanged: () {
          setState(() {
            formValidVN.value = formkey.currentState?.validate() ?? false;
          });
        },
        child: CustomTextFormField(
          prefixIcon: const Icon(Icons.mail),
          label: Consts.textEmail,
          controller: emailController,
          hintText: Consts.textHintTextEmail,
          validator: validateMail,
          suffix: InputClear(controller: emailController),
          textInputAction: TextInputAction.next,
        ),
      ),
      actions: [
        ValueListenableBuilder(
          //Habilta de desabilita o botão
          valueListenable: formValidVN,
          builder: (_, formValid, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () =>
                        Modular.to.popAndPushNamed(ConstsRoutes.loginPage),
                    child:
                        const Text(Consts.textCancelarCustomShowAlertDialog)),
                TextButton(
                    onPressed: !formValid
                        ? null
                        : () => Modular.to.pop(emailController.text),
                    child: const Text(Consts.textEnviarCustomShowAlertDialog))
              ],
            );
          },
        ),
      ],
    );
  }
}
