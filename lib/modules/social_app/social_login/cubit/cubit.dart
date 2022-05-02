// @dart=2.9
import 'package:fast_chat/layout/social_app/cubit/cubit.dart';
import 'package:fast_chat/shared/network/local/cache_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fast_chat/modules/social_app/social_login/cubit/states.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    @required String email,
    @required String password,
    @required BuildContext context,
  }) {

    emit(SocialLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((value) async {

            await CacheHelper.saveData(value:value.user.uid ,key: 'uId');
            SocialCubit.get(context).getUsers();

          emit(SocialLoginSuccessState(value.user.uid));
    })
        .catchError((error)
    {
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(SocialChangePasswordVisibilityState());
  }
}
