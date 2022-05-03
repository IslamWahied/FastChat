// @dart=2.9

import 'package:fast_chat/shared/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fast_chat/layout/social_app/cubit/cubit.dart';
import 'package:fast_chat/layout/social_app/social_layout.dart';

import 'package:fast_chat/modules/social_app/social_login/social_login_screen.dart';

import 'package:fast_chat/shared/components/constants.dart';
import 'package:fast_chat/shared/cubit/cubit.dart';
import 'package:fast_chat/shared/cubit/states.dart';
import 'package:fast_chat/shared/network/local/cache_helper.dart';

import 'package:fast_chat/shared/styles/themes.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Bloc.observer = MyBlocObserver();

  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  //bool onBoarding = CacheHelper.getData(key: 'onBoarding');

  uId = CacheHelper.getData(key: 'uId');
  debugPrint('UID');

  debugPrint(uId.toString());
  debugPrint('UID');

  // if(onBoarding != null)
  // {
  //   if(token != null) widget = ShopLayout();
  //   else widget = ShopLoginScreen();
  // } else
  //   {
  //     widget = OnBoardingScreen();
  //   }

  if (uId != null && uId.trim() != '') {
    widget = const SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget {
  // constructor
  // build
  final bool isDark;
  final Widget startWidget;

  const MyApp({
    Key key,
    this.isDark,
    this.startWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getUserData()
            ..getUsers()
            ..getMessages()
          ..getAllGroups(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: defaultColor,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                titleSpacing: 20.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                titleTextStyle: TextStyle(
                  fontFamily: 'Jannah',
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: defaultColor,
                unselectedItemColor: Colors.grey,
                elevation: 20.0,
                backgroundColor: Colors.white,
              ),
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                subtitle1: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              fontFamily: 'Jannah',
            ),

            themeMode: ThemeMode.light,
            // home: SocialRegisterScreen(),
            home: startWidget,
            //   home: SocialLoginScreen(),
          );
        },
      ),
    );
  }
}

// ./gradlew signingReport
