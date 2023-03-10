import 'dart:developer';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/home_flow/plannings/plannings_event.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/home_flow/plannings/plannings_repository.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/modules/home_flow/plannings/plannings_state.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/shared/models/plannings/planning_model.dart';
import 'package:projeto_gestao_financeira_grupo_nove/src/shared/models/user_model.dart';

class PlanningsBloc extends Bloc<PlanningsPageEvent, PlanningsState> {

  final PlanningsRepository repository;
  final String? id;
  UserModel? userModel;

  PlanningsBloc(
    {required this.repository,
     required this.id,
     this.userModel,}
  ) : super(PlanningsStateEmpty()) {
    log('plannings page bloc created');
    on<OnPlanningsInitState>(getUserData);
  }

  Future<void> getUserData(
    PlanningsPageEvent event,
    Emitter<PlanningsState> emitter) async {
    try {
      emitter(PlanningsStateLoading());
      final userModel = await repository.getUserData(userID: id!);
      List<PlanningModel>? plannings = [];
      plannings = await repository.getPlannings(userID: id!);

      if (plannings!.isNotEmpty) {
        emitter(PlanningsStateSuccess(user: userModel,
                                             plannings: plannings));
      } else {
        emitter(PlanningsStateEmpty());
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
      emitter(PlanningsStateError(erro: e));
    }
  }

}