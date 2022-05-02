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
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';


class GroupsScreen extends StatelessWidget {
  const GroupsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=SocialCubit.get(context);

        final groups = cubit.listUsers
            .map(
                (element) => MultiSelectItem<SocialUserModel>(element, element.name))
            .toList();
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
                                  height: MediaQuery.of(context).size.height * 0.6,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: defaultFormField(
                                            controller: cubit.txtGroupNameController,
                                            type: TextInputType.name,
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return 'please enter your group name';
                                              }
                                            },
                                            label: 'Group Name',
                                            prefix: Icons.group_add,
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        SizedBox(
                                          height:
                                          MediaQuery.of(context).size.height /
                                              33,
                                        ),
                                        MultiSelectDialogField(
                                          onConfirm: (val) {
                                            cubit.selectUsers(val);
                                          },
                                          buttonIcon: const Icon(Icons.arrow_drop_down_sharp),
                                          itemsTextStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                          dialogWidth: MediaQuery.of(context).size.width * 0.7,
                                          dialogHeight:
                                          MediaQuery.of(context).size.height * 0.5,
                                          backgroundColor: Colors.blueGrey[50],
                                          cancelText: const Text(
                                            'CANCEL',
                                            style: TextStyle(
                                                color: Colors.red, fontWeight: FontWeight.w500),
                                          ),
                                          items: groups,
                                          initialValue: cubit.selectedUsers,
                                        ),



                                      ],
                                    ),
                                  ),
                                ),
                                elevation: 24,
                                actions: [
                                  TextButton(onPressed: (){






                                  }, child: const Text('OK')),
                                  TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('CANCEL',style: TextStyle(color: Colors.red),)),
                                ],
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
                            Icon(Icons.group_add,color: Colors.white,),
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


  Widget selectUsersItem(){





  }
}
