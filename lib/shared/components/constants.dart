// @dart=2.9
// POST
// UPDATE
// DELETE

// GET

// base url : https://newsapi.org/
// method (url) : v2/top-headlines?
// queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

// https://newsapi.org/v2/everything?q=tesla&apiKey=65f7f556ec76449fa7dc7c0069f040ca


import 'package:fast_chat/shared/network/local/cache_helper.dart';

void signOut(context)
{
  CacheHelper.removeData(
    key: 'token',
  ).then((value)
  {
    if (value)
    {
      // navigateAndFinish(
      //   context,
      //   // ShopLoginScreen(),
      // );
    }
  });
}



String token = '';

String uId = '';