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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context,setState){
                              return AlertDialog(
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Sort by:',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState((){
                                                    //  cubit.changeUpperSort();

                                                    });
                                                  },
                                                  child: const CircleAvatar(
                                                    radius: 15,
                                                    child: Icon(
                                                      Icons.arrow_downward,
                                                      color: Colors.white,
                                                      size: 17,
                                                    ),

                                                  //  cubit.LowerColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.03,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState((){
                                                     // cubit.changeLowerSort();

                                                    });
                                                  },
                                                  child: const CircleAvatar(
                                                    radius: 15,
                                                    child: Icon(
                                                      Icons.arrow_upward,
                                                      color: Colors.white,
                                                      size: 17,
                                                    ),

                                                   // cubit.upperColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        SizedBox(
                                          height:
                                          MediaQuery.of(context).size.height /
                                              33,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            //cubit.sortByDate(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Sort by date',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              Icon(Icons.sort)
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                          MediaQuery.of(context).size.height /
                                              33,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            //cubit.sortByNum(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'Sort by case number',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              Icon(Icons.sort)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                elevation: 24,
                                backgroundColor: Colors.blueGrey[50],
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                              );
                            },

                          );
                        },
                      );


























                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.blue),
                        child: Row(
                          children: const [
                            Text('New Group',style: TextStyle(color: Colors.white),),
                            SizedBox(width: 5,),
                            Icon(Icons.add,color: Colors.white,),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ConditionalBuilder(
                condition: cubit.listUsers.isNotEmpty && cubit.listUsers.where((element) => element.uId != uId).toList().isNotEmpty,
                builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildChatItem( cubit.listUsers.where((element) => element.uId != uId).toList()[index], context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: SocialCubit.get(context).listUsers.where((element) => element.uId != uId).toList().length,
                ),
                fallback: (context) => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
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
