
// ignore_for_file: deprecated_member_use

// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_chat/modules/social_app/groups/groups.dart';
import 'package:fast_chat/modules/social_app/social_login/social_login_screen.dart';
import 'package:fast_chat/shared/components/components.dart';
import 'package:fast_chat/shared/network/local/cache_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fast_chat/layout/social_app/cubit/states.dart';
import 'package:fast_chat/models/social_app/message_model.dart';

import 'package:fast_chat/models/social_app/social_user_model.dart';
import 'package:fast_chat/modules/social_app/chats/chats_screen.dart';


import 'package:fast_chat/modules/social_app/settings/settings_screen.dart';

import 'package:fast_chat/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {

      debugPrint(value.data().toString());

      userModel = SocialUserModel.fromJson(value.data());

      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [

    const ChatsScreen(),
    const GroupsScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [

    'Chats',
    'Groups',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 0||index==1) {

      currentIndex = index;
      emit(SocialChangeBottomNavState());


    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);

      emit(SocialProfileImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  // image_picker7901250412914563370.jpg





  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadProfileImageSuccessState());
        debugPrint(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }




  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String cover,
    String image,
  }) {

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
        'SubCategory/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        SocialUserModel model = SocialUserModel(
          name: name,
          phone: phone,
          bio: bio,
          email: userModel.email,
          cover: cover ?? userModel.cover,
          image: value ?? userModel.image,
          uId: userModel.uId,
          isEmailVerified: false,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(userModel.uId)
            .update(model.toMap())
            .then((value) {
          getUserData();
        }).catchError((error) {
          emit(SocialUserUpdateErrorState());
        });
      });
    });
  }

  File postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      debugPrint('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }






  List<SocialUserModel> listUsers = [];




  void getUsers() {
    listUsers=[];
    if (listUsers.isEmpty) {


      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .listen((event) {
        listUsers = event.docs.map((x) => SocialUserModel.fromJson(x.data())).toList();
        emit(SocialGetAllUsersSuccessState());
      }).onError((handleError){
        debugPrint(handleError.toString());
        emit(SocialGetAllUsersErrorState(handleError.toString()));
      });





    }
  }

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel.uId,
      receiverId: receiverId,
      groupId: '0',
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('chat')
        .add(model.toMap())
        .then((value) {

      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });


  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('chat')
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {

        messages.add(MessageModel.fromJson(element.data()));
      }

      print('userModel.uId');
      print(userModel.uId);
      print('userModel.uId');

      messages = messages.where((element) => element.receiverId == userModel.uId || element.senderId == userModel.uId).toList();

      messages.sort((b, a) {
        var aDate = b.dateTime;
        var bDate = a.dateTime;
        return bDate.compareTo(
            aDate);
      });

      emit(SocialGetMessagesSuccessState());
    });
  }




  void signOut(context)async{
    await FirebaseAuth.instance.signOut();
    await CacheHelper.saveData(key: 'uId',value: '');

    navigateAndFinish(context, SocialLoginScreen());
    emit(SocialSignOutState());


  }

  var txtGroupNameController=TextEditingController();

  List<SocialUserModel> selectedUsers = [];

  void selectUsers(val) {
    selectedUsers = val;
    // for (var element in selectedGroups) {
    //   groups.add(element.name);
    // }
    emit(HomeSelectedUsersState());
  }

void addGroup(){




}



}
