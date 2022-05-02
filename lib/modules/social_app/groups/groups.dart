// @dart=2.9
import 'package:conditional_builder/conditional_builder.dart';
import 'package:fast_chat/layout/social_app/cubit/cubit.dart';
import 'package:fast_chat/layout/social_app/cubit/states.dart';
import 'package:fast_chat/models/social_app/social_user_model.dart';
import 'package:fast_chat/modules/social_app/groups_details/groups_detals.dart';

import 'package:fast_chat/shared/components/components.dart';
import 'package:fast_chat/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=SocialCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.listUsers.isNotEmpty && cubit.listUsers.where((element) => element.uId != uId).toList().isNotEmpty,
          builder: (context) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildChatItem( cubit.listUsers.where((element) => element.uId != uId).toList()[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: SocialCubit.get(context).listUsers.where((element) => element.uId != uId).toList().length,
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
    onTap: () {
      navigateTo(
        context,
        GroupDetailsScreen(
          userModel: model,
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              model.image,
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Text(
            model.name,
            style: const TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}
