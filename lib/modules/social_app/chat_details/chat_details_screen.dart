// @dart=2.9
// ignore_for_file: must_be_immutable

import 'package:conditional_builder/conditional_builder.dart';
import 'package:fast_chat/layout/social_app/cubit/cubit.dart';
import 'package:fast_chat/layout/social_app/cubit/states.dart';
import 'package:fast_chat/models/social_app/message_model.dart';
import 'package:fast_chat/models/social_app/social_user_model.dart';
import 'package:fast_chat/shared/components/constants.dart';
import 'package:fast_chat/shared/styles/colors.dart';
import 'package:fast_chat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;

  ChatDetailsScreen({
    Key key,
    this.userModel,
  }) : super(key: key);

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(
          receiverId: userModel.uId,
        );
        SocialCubit.get(context).getLocation();
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        userModel.image,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      userModel.name,
                    ),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ListView.separated(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index)
                          {
                            var message = cubit.messages.where((element) => (element.senderId == uId || element.receiverId == uId) && (element.senderId == userModel.uId || element.receiverId == userModel.uId) && element.groupId == '0' ).toList()[index];
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messages[index];

                            if(cubit.userModel.uId == message.senderId) {
                            if (SocialCubit.get(context).userModel.uId ==
                                    message.senderId &&
                                message.longitude == null &&
                                message.latitude == null) {
                              return buildMyMessage(message);
                            } else if (SocialCubit.get(context).userModel.uId ==
                                    message.senderId &&
                                message.longitude != null &&
                                message.latitude != null) {
                              return buildMyLocationMessage(message, context);
                            } else {
                              return buildMessage(message);
                            }
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15.0,
                          ),
                          itemCount: cubit.messages.where((element) => (element.senderId == uId || element.receiverId == uId) && (element.senderId == userModel.uId || element.receiverId == userModel.uId) && element.groupId == '0' ).toList().length,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your message here ...',
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 50.0,
                                  color: defaultColor,
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).sendMessage(
                                        receiverId: userModel.uId,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text,
                                      );
                                      messageController.clear();
                                    },
                                    minWidth: 1.0,
                                    child: const Icon(
                                      IconBroken.Send,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 50.0,
                                  color: defaultColor,
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).sendMessage(
                                        receiverId: userModel.uId,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text,
                                        latitude: SocialCubit.get(context)
                                            .locationData
                                            .latitude,
                                        longitude: SocialCubit.get(context)
                                            .locationData
                                            .longitude,
                                      );
                                      messageController.clear();

                                      // SocialCubit.get(context).getLocation();
                                    },
                                    minWidth: 1.0,
                                    child: const Icon(
                                      Icons.add_location,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            model.text,
          ),
        ),
      );

  Widget buildMyMessage(
    MessageModel model,
  ) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(
              .2,
            ),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            model.text,
          ),
        ),
      );

  Widget buildMyLocationMessage(MessageModel model, context) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: InkWell(
            onTap: () {
              SocialCubit.get(context).goToMap(model.latitude, model.longitude);
            },
            child: const SizedBox(
              width: 200,
              child: Card(
                  elevation: 5,
                  child: Image(
                    image: AssetImage('assets/images/location.jpg'),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )),
            )),
      );
}
