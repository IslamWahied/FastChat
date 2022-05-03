// @dart=2.9
// ignore_for_file: must_be_immutable

import 'package:conditional_builder/conditional_builder.dart';
import 'package:fast_chat/layout/social_app/cubit/cubit.dart';
import 'package:fast_chat/layout/social_app/cubit/states.dart';
import 'package:fast_chat/models/social_app/groupModel.dart';
import 'package:fast_chat/models/social_app/groupModel.dart';
import 'package:fast_chat/models/social_app/message_model.dart';
import 'package:fast_chat/models/social_app/social_user_model.dart';
import 'package:fast_chat/shared/components/constants.dart';
import 'package:fast_chat/shared/styles/colors.dart';
import 'package:fast_chat/shared/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GroupDetailsScreen extends StatelessWidget {
  GroupModel groupModel;

  GroupDetailsScreen({Key key,
    this.groupModel,
  }) : super(key: key);

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {

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
                    child: Text(groupModel.groupName[0].toUpperCase()),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      groupModel.groupName,
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
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 15.0,
                            ),
                            itemCount: cubit.messages.where((element) => element.groupId == groupModel.groupId ).toList().length,



                            itemBuilder: (context, index) {
                              var message = cubit.messages.where((element) => element.groupId == groupModel.groupId ).toList()[index];

                              // Check Sender Or Receiver

                              //Sender
                              if( message.senderId ==  uId ){
                                // Check Normal Message Or Location

                                // normal
                                if(message.longitude == null && message.latitude == null){

                                  return buildMyMessage(message);

                                }

                                // location
                                else{

                                  return buildMyLocationMessage(message,context);
                                }


                              }
                              // Receiver
                              else{

                                // Check Normal Message Or Location

                                // normal
                                if(message.longitude == null && message.latitude == null){

                                  return buildMessage(message,context);

                                }

                                // location
                                else{

                                  return buildReceiverLocationMessage(message,context);
                                }


                              }

                            }

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
                                      cubit.sendMessage(
                                        groupId:groupModel.groupId,
                                        receiverId: '',
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
                                      cubit.sendMessage(
                                        receiverId: '',
                                        groupId: groupModel.groupId,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text,
                                        latitude: cubit.locationData.latitude,
                                        longitude: cubit
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

  Widget buildMessage(MessageModel model,context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      CircleAvatar(
        radius: 20.0,
        backgroundImage: NetworkImage(
          SocialCubit.get(context).listUsers.firstWhere((element) => element.uId == model.senderId).image??'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
        ),
      ),
      const SizedBox(width: 10),
      Column(
crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(SocialCubit.get(context).listUsers.firstWhere((element) => element.uId == model.senderId).name),
          const SizedBox(height: 5,),
          Align(
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
          ),
        ],
      ),
    ],
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
  Widget buildReceiverLocationMessage(MessageModel model, context) => Align(
    alignment: AlignmentDirectional.centerStart,
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
