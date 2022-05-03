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


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await CacheHelper.init();

  Widget widget;

  uId = CacheHelper.getData(key: 'uId');

  if (uId != null && uId.trim() != '') {
    widget = const SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({
    Key key,
    this.startWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()),
        BlocProvider(
          create: (BuildContext context) => SocialCubit()
            ..getUserData()
            ..getUsers()
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
