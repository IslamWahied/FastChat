// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fast_chat/layout/social_app/cubit/cubit.dart';
import 'package:fast_chat/layout/social_app/cubit/states.dart';
import 'package:fast_chat/modules/social_app/edit_profile/edit_profile_screen.dart';

import 'package:fast_chat/shared/components/components.dart';
import 'package:fast_chat/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if(cubit.userModel != null &&  cubit.userModel.image != null)
                SizedBox(
                  height: 140.0,
                  child: CircleAvatar(
                    radius: 64.0,
                    backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: NetworkImage(
                        cubit.userModel.image??'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  cubit.userModel.name,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 5.0,
                ),

                Text(
                  cubit. userModel.bio,
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(
                  height: 15.0,
                ),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          navigateTo(
                            context,
                            EditProfileScreen(),
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Edit Profile',
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                IconBroken.Edit,
                                size: 16.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: (){
                      SocialCubit.get(context).signOut(context);

                    }, icon: const Icon(
                      Icons.logout,

                      color: Colors.red,
                    ),)
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),

                ListTile(leading: const Icon(Icons.person),title: Text(cubit.userModel.name),),
                const SizedBox(
                  height: 15.0,
                ),

                ListTile(leading: const Icon(Icons.note_add_outlined),title: Text(cubit.userModel.bio),),
                const SizedBox(
                  height: 15.0,
                ),

                ListTile(leading: const Icon(Icons.email),title: Text(cubit.userModel.email),),
                const SizedBox(
                  height: 15.0,
                ),

                ListTile(leading: const Icon(Icons.phone),title: Text(cubit.userModel.phone),),
                const SizedBox(
                  height: 15.0,
                ),




              ],
            ),
          ),
        );
      },
    );
  }
}
